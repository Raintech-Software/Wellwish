"""Partner app: documents and verification status (/v1/partner/kyc/*, §6.3, §10.3).
Works at any status (the status screen and documents screen stay open before approval)."""

from django.http import HttpRequest
from ninja import Router

from apps.files import services as files
from apps.files.schemas import PartnerUploadUrlIn, UploadUrlOut
from apps.kyc import selectors, services
from apps.kyc.api.out import required_out, status_out
from apps.kyc.schemas import DocumentIn, KycStatusOut, RequiredDocumentOut
from apps.partners.api.out import own_partner
from common.auth import get_principal

router = Router(tags=["partner"])


@router.get(
    "/kyc/required",
    response=list[RequiredDocumentOut],
    by_alias=True,
    operation_id="partnerKycRequired",
)
def required(request: HttpRequest) -> list[RequiredDocumentOut]:
    """The documents for the partner's role (§6.3 list; the admin can change it)."""
    partner = own_partner(get_principal(request).subject_id)
    return [required_out(r) for r in selectors.required_documents(partner.role)]


@router.post(
    "/kyc/upload-url", response=UploadUrlOut, by_alias=True, operation_id="partnerKycUploadUrl"
)
def upload_url(request: HttpRequest, data: PartnerUploadUrlIn) -> UploadUrlOut:
    """Step 1 of an upload (profile photo or a document): PUT the file to `uploadUrl`, then
    send `fileKey` with the profile or document."""
    user_id = get_principal(request).subject_id
    own_partner(user_id)
    ticket = files.create_upload(
        purpose=data.purpose, mime=data.mime, size_bytes=data.size_bytes, owner=str(user_id)
    )
    return UploadUrlOut(
        file_key=ticket.file_key,
        upload_url=ticket.upload_url,
        upload_fields=ticket.upload_fields,
        mime=ticket.mime,
        max_bytes=ticket.max_bytes,
    )


@router.post(
    "/kyc/documents", response=KycStatusOut, by_alias=True, operation_id="partnerKycDocumentAdd"
)
def add_document(request: HttpRequest, data: DocumentIn) -> KycStatusOut:
    """Attach an uploaded document (number masked for Aadhaar/PAN; expiry date if needed).
    A new upload of the same type replaces the old one."""
    user_id = get_principal(request).subject_id
    services.add_document(
        user_id=user_id,
        data=services.DocumentInput(
            doc_type=data.doc_type,
            file_key=data.file_key,
            number=data.number,
            expires_on=data.expires_on,
        ),
    )
    return status_out(own_partner(user_id))


@router.post("/kyc/submit", response=KycStatusOut, by_alias=True, operation_id="partnerKycSubmit")
def submit(request: HttpRequest) -> KycStatusOut:
    """Send the application for review (§6.3 step 7)."""
    user_id = get_principal(request).subject_id
    services.submit(user_id=user_id)
    return status_out(own_partner(user_id))


@router.get("/kyc/status", response=KycStatusOut, by_alias=True, operation_id="partnerKycStatus")
def status(request: HttpRequest) -> KycStatusOut:
    """Everything for the registration, documents and status screens (R04 to R07, R16)."""
    user_id = get_principal(request).subject_id
    return status_out(own_partner(user_id))
