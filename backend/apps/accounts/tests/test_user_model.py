import pytest
from django.contrib.auth import get_user_model
from django.db import IntegrityError

from common.phone import InvalidPhone

User = get_user_model()


@pytest.mark.django_db
def test_create_user_normalizes_phone_and_has_no_password():
    user = User.objects.create_user("98765 43210")
    assert user.phone == "+919876543210"
    assert not user.has_usable_password()  # patients/partners log in with OTP
    assert user.status == "ACTIVE"
    assert user.language == "en"
    assert user.id is not None


@pytest.mark.django_db
def test_phone_is_unique():
    User.objects.create_user("9876543210")
    with pytest.raises(IntegrityError):
        User.objects.create_user("+919876543210")


@pytest.mark.django_db
def test_rejects_non_indian_numbers():
    with pytest.raises(InvalidPhone):
        User.objects.create_user("+14155550123")


@pytest.mark.django_db
def test_superuser_needs_password():
    with pytest.raises(ValueError):
        User.objects.create_superuser("9876543210")
    admin = User.objects.create_superuser("9876543211", password="a-long-dev-password")
    assert admin.is_staff
    assert admin.is_superuser
    assert admin.check_password("a-long-dev-password")


def test_user_model_is_the_custom_one():
    assert User._meta.label == "accounts.User"
    assert User.USERNAME_FIELD == "phone"
