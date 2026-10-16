"""Partner: the reviews they got (R15, §6.13). No names."""

from django.http import HttpRequest
from ninja import Router

from apps.assignments import selectors as assignment_selectors
from apps.reviews import selectors
from apps.reviews.api.out import partner_review_out
from apps.reviews.schemas import PartnerReviewOut
from common.auth import get_principal

router = Router(tags=["partner"])


@router.get(
    "/reviews", response=list[PartnerReviewOut], by_alias=True, operation_id="partnerReviews"
)
def reviews(request: HttpRequest) -> list[PartnerReviewOut]:
    """The latest 20 visible reviews."""
    partner = assignment_selectors.partner_of(get_principal(request).subject_id)
    return [partner_review_out(r) for r in selectors.partner_reviews(str(partner.pk))]
