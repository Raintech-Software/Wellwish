"""Money is always an integer number of paise (₹1 = 100 paise). Never use floats (CLAUDE.md)."""

from decimal import ROUND_HALF_UP, Decimal, InvalidOperation

Paise = int


def to_paise(rupees: Decimal | int | str) -> Paise:
    """'499.50' → 49950. Rejects floats and amounts with fractions of a paisa."""
    if isinstance(rupees, (bool, float)):
        raise TypeError("Use Decimal, int or str for money, never float or bool.")
    try:
        amount = Decimal(str(rupees).strip())
    except InvalidOperation as exc:
        raise ValueError(f"Not a money amount: {rupees!r}") from exc
    paise = amount * 100
    if paise != paise.to_integral_value():
        raise ValueError(f"Amount has fractions of a paisa: {rupees!r}")
    return int(paise)


def percent_of(paise: Paise, percent: int | Decimal) -> Paise:
    """Share of an amount, rounded half-up to whole paise. percent_of(10000, 50) == 5000."""
    _require_int(paise)
    if isinstance(percent, float):
        raise TypeError("Use int or Decimal for percentages, never float.")
    share = Decimal(paise) * Decimal(percent) / Decimal(100)
    return int(share.quantize(Decimal(1), rounding=ROUND_HALF_UP))


def format_inr(paise: Paise, *, always_show_paise: bool = False) -> str:
    """Indian grouping: 12345600 → '₹1,23,456'; 49950 → '₹499.50'."""
    _require_int(paise)
    sign = "-" if paise < 0 else ""
    rupees, rem = divmod(abs(paise), 100)
    text = _indian_grouping(rupees)
    if rem or always_show_paise:
        text += f".{rem:02d}"
    return f"{sign}₹{text}"


def _indian_grouping(n: int) -> str:
    digits = str(n)
    if len(digits) <= 3:
        return digits
    head, tail = digits[:-3], digits[-3:]
    groups: list[str] = []
    while len(head) > 2:
        groups.insert(0, head[-2:])
        head = head[:-2]
    if head:
        groups.insert(0, head)
    return ",".join(groups) + "," + tail


def _require_int(value: object) -> None:
    if isinstance(value, bool) or not isinstance(value, int):
        raise TypeError("Money must be an integer number of paise.")
