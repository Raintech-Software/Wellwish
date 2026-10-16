import pytest

from common.phone import InvalidPhone, mask_phone, normalize_indian_mobile


@pytest.mark.parametrize(
    "raw",
    [
        "9876543210",
        "+919876543210",
        "919876543210",
        "09876543210",
        "+91 98765-43210",
        "(987) 654 3210",
    ],
)
def test_normalize_accepts_common_formats(raw):
    assert normalize_indian_mobile(raw) == "+919876543210"


@pytest.mark.parametrize(
    "raw",
    ["", "12345", "5876543210", "+14155550123", "98765432101", "abcdefghij", "+9198765432"],
)
def test_normalize_rejects_non_indian_mobiles(raw):
    with pytest.raises(InvalidPhone):
        normalize_indian_mobile(raw)


def test_mask_phone_hides_the_middle():
    assert mask_phone("+919876543210") == "+91******3210"
    assert "98765" not in mask_phone("+919876543210")
