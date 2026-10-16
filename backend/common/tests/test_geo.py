from decimal import Decimal

import pytest
from django.db import connection, models
from django.test.utils import isolate_apps

from common.geo import bounding_box, haversine_km, nearby

# Bhubaneswar, Master Canteen (approx.)
BBSR = (20.2700, 85.8400)


def test_haversine_one_degree_on_equator():
    assert haversine_km(0, 0, 0, 1) == pytest.approx(111.19, abs=0.05)


def test_haversine_same_point_is_zero():
    assert haversine_km(*BBSR, *BBSR) == 0


def test_bounding_box_contains_points_at_the_radius():
    min_lat, max_lat, min_lng, max_lng = bounding_box(*BBSR, 10)
    assert min_lat < BBSR[0] < max_lat
    assert min_lng < BBSR[1] < max_lng
    # a point 10 km due north is inside the box
    assert BBSR[0] + 10 / 111.32 <= max_lat + 1e-9


@pytest.mark.django_db
@isolate_apps("common")
def test_nearby_filters_and_sorts_by_distance():
    class Place(models.Model):
        name = models.CharField(max_length=50)
        lat = models.DecimalField(max_digits=9, decimal_places=6)
        lng = models.DecimalField(max_digits=9, decimal_places=6)

        class Meta:
            app_label = "common"

    with connection.schema_editor() as editor:
        editor.create_model(Place)
    try:
        places = Place._default_manager
        # ~1.1 km, ~5.6 km and ~25.6 km north of BBSR
        places.create(name="near", lat=Decimal("20.2800"), lng=Decimal("85.8400"))
        places.create(name="mid", lat=Decimal("20.3200"), lng=Decimal("85.8400"))
        places.create(name="far", lat=Decimal("20.5000"), lng=Decimal("85.8400"))

        results = list(nearby(places.all(), *BBSR, 10))

        assert [p.name for p in results] == ["near", "mid"]
        nearest_km = results[0].distance_km  # type: ignore[attr-defined]
        assert nearest_km == pytest.approx(1.11, abs=0.05)
    finally:
        with connection.schema_editor() as editor:
            editor.delete_model(Place)
