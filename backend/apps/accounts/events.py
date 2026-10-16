"""Events published by accounts (ARCHITECTURE §10.2).

- `otp.locked` {phone_masked, purpose}: a phone was locked after 10 wrong codes in an hour.
  The admin alert for it is wired up with the admin alerts (Phase 7).
"""
