from decimal import Decimal

import pytest

from common.money import format_inr, percent_of, to_paise


@pytest.mark.parametrize(
    ("rupees", "paise"),
    [("100", 10000), ("499.50", 49950), (Decimal("0.01"), 1), (500, 50000), (" 12.5 ", 1250)],
)
def test_to_paise(rupees, paise):
    assert to_paise(rupees) == paise


def test_to_paise_rejects_float_and_bool():
    with pytest.raises(TypeError):
        to_paise(10.5)  # type: ignore[arg-type]
    with pytest.raises(TypeError):
        to_paise(True)


def test_to_paise_rejects_fraction_of_paisa_and_junk():
    with pytest.raises(ValueError):
        to_paise("1.005")
    with pytest.raises(ValueError):
        to_paise("abc")


def test_percent_of_refund_is_exact():
    # 50% refund of a ₹100 booking fee is exactly ₹50 (ARCHITECTURE §6.12)
    assert percent_of(10000, 50) == 5000
    # rounding is half-up to whole paise
    assert percent_of(101, 50) == 51
    assert percent_of(99, 50) == 50
    with pytest.raises(TypeError):
        percent_of(10000, 50.0)  # type: ignore[arg-type]
    with pytest.raises(TypeError):
        percent_of(100.0, 50)  # type: ignore[arg-type]


@pytest.mark.parametrize(
    ("paise", "text"),
    [
        (0, "₹0"),
        (10000, "₹100"),
        (49950, "₹499.50"),
        (12345600, "₹1,23,456"),
        (1234567800, "₹1,23,45,678"),
        (-5000, "-₹50"),
    ],
)
def test_format_inr_uses_indian_grouping(paise, text):
    assert format_inr(paise) == text


def test_format_inr_always_show_paise():
    assert format_inr(10000, always_show_paise=True) == "₹100.00"
