"""Distances on plain latitude/longitude columns (no PostGIS — ARCHITECTURE §6.7).

`nearby()` first filters by a bounding box (cheap, uses the lat/lng index), then computes
the exact great-circle distance in SQL and keeps rows within `km`, closest first.
"""

import math
from typing import Any

from django.db.models import F, FloatField, Model, QuerySet, Value
from django.db.models.functions import ASin, Cast, Cos, Least, Power, Radians, Sin, Sqrt

EARTH_RADIUS_KM = 6371.0088
_KM_PER_DEGREE_LAT = 111.32


def haversine_km(lat1: float, lng1: float, lat2: float, lng2: float) -> float:
    p1, p2 = math.radians(lat1), math.radians(lat2)
    dlat = p2 - p1
    dlng = math.radians(lng2 - lng1)
    a = math.sin(dlat / 2) ** 2 + math.cos(p1) * math.cos(p2) * math.sin(dlng / 2) ** 2
    return 2 * EARTH_RADIUS_KM * math.asin(min(1.0, math.sqrt(a)))


def bounding_box(lat: float, lng: float, km: float) -> tuple[float, float, float, float]:
    """(min_lat, max_lat, min_lng, max_lng) that contains every point within `km`."""
    dlat = km / _KM_PER_DEGREE_LAT
    cos_lat = max(math.cos(math.radians(lat)), 0.01)  # avoid blowing up near the poles
    dlng = km / (_KM_PER_DEGREE_LAT * cos_lat)
    return lat - dlat, lat + dlat, lng - dlng, lng + dlng


def haversine_expression(
    lat: float, lng: float, lat_field: str = "lat", lng_field: str = "lng"
) -> Any:
    """SQL expression: distance in km from (lat, lng) to each row's (lat_field, lng_field)."""
    row_lat = Cast(F(lat_field), FloatField())
    row_lng = Cast(F(lng_field), FloatField())
    lat0 = Value(float(lat), output_field=FloatField())
    lng0 = Value(float(lng), output_field=FloatField())
    two = Value(2.0, output_field=FloatField())
    a = Power(Sin(Radians(row_lat - lat0) / two), two) + Cos(Radians(lat0)) * Cos(
        Radians(row_lat)
    ) * Power(Sin(Radians(row_lng - lng0) / two), two)
    one = Value(1.0, output_field=FloatField())
    radius = Value(2 * EARTH_RADIUS_KM, output_field=FloatField())
    return radius * ASin(Least(Sqrt(a), one))


def nearby[M: Model](
    queryset: QuerySet[M],
    lat: float,
    lng: float,
    km: float,
    *,
    lat_field: str = "lat",
    lng_field: str = "lng",
) -> QuerySet[M]:
    """Rows within `km` of (lat, lng), annotated with `distance_km`, closest first."""
    min_lat, max_lat, min_lng, max_lng = bounding_box(lat, lng, km)
    return (
        queryset.filter(
            **{
                f"{lat_field}__gte": min_lat,
                f"{lat_field}__lte": max_lat,
                f"{lng_field}__gte": min_lng,
                f"{lng_field}__lte": max_lng,
            }
        )
        .annotate(distance_km=haversine_expression(lat, lng, lat_field, lng_field))
        .filter(distance_km__lte=km)
        .order_by("distance_km")
    )
