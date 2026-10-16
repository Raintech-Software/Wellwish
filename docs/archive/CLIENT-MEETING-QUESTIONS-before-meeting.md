# WellWish — Key Questions for the Client

> **Meeting:** Wed 7 Oct 2026 · **Related:** [ARCHITECTURE.md](ARCHITECTURE.md) (§6 core logic, §17 open decisions)
>
> 27 important logic questions. Each has options, **our default** (what the architecture assumes today), and what it changes in the app.

- Only the logic questions that change money flow, booking rules or who is responsible.
- Our default is what the architecture assumes now. If the client agrees, there is no rework.

## Money flow we assume today

Confirm this table first. Most money questions below change one cell of it.

| Service | Patient pays | When | Paid to | Partner gets | WellWish keeps | Questions |
|---|---|---|---|---|---|---|
| Doctor consultation | Doctor's fee | At the hospital counter | Hospital / doctor directly | Full fee | ₹30 booking fee, paid online | M1, E1 |
| Companion visit | Base + per km + per hour | After the visit | WellWish in the app, or companion in cash | 80% of the fare | 20% | M2, M3, E2 |
| Cab / auto to hospital | Actual fare | During the trip | Driver directly | — | — | M4 |
| Hospital bills, tests, medicines | Actual bill | At the counter | Hospital / pharmacy directly | — | — | M5 |
| Home nurse visit or shift | Per visit / per shift | After each visit | WellWish in the app, or nurse in cash | 80% | 20% | M2, E2 |
| Nursing supplies | Actual cost | Before the visit | Pharmacy (family buys) | — | — | N1 |
| Membership | ₹299 / ₹799 / ₹2,999 | At subscribe, auto-renews | WellWish | — | 100% | S1–S6 |
| Extra family members | ₹49 / month each after 2 free | Monthly | WellWish | — | 100% | S2 |

## How WellWish earns: example

| Booking | Patient pays | Partner gets | WellWish keeps |
|---|---|---|---|
| Doctor appointment (fee paid at counter) | ₹30 online + doctor's fee at counter | Doctor: full fee | ₹30 |
| Companion visit, normal patient (₹742 fare) | ₹742 | ₹594 (80%) | ₹148 (20%) |
| Same visit, Premium member (10% off) | ₹668 | ₹594 (still 80% of full fare) | ₹74 |
| Premium membership, monthly | ₹299 | — | ₹299 |

A member's 10% discount costs WellWish ₹74 on a visit like this. ₹299 a month covers about 4 such visits. After that, WellWish earns less from a member than from a normal patient (see S4 and S5).

## M. Money

### M1 — Who collects the doctor's consultation fee?

- [ ] **A.** Patient pays at the hospital counter. WellWish only takes a small booking fee online.
- [ ] **B.** Patient pays the full fee online in the app. WellWish pays the doctor or hospital later.
- [ ] **C.** Both. Set separately for each doctor. **← our default**

**Our default:** C. Start every doctor on A.

**Changes in the app:** Whether doctor booking needs online payment, doctor-fee refunds and payouts to doctors.

**Client's answer:** 

### M2 — For companion and nurse jobs, who does the patient pay?

- [ ] **A.** WellWish, in the app. WellWish pays the partner weekly, minus commission.
- [ ] **B.** The partner directly, in cash or UPI. The partner then pays WellWish its commission.
- [ ] **C.** Patient chooses: in the app, or cash to the partner. **← our default**

**Our default:** C. For cash jobs, WellWish's share is taken from the partner's next weekly payout.

**Changes in the app:** Checkout, partner wallet and payouts.

**Client's answer:** 

### M3 — When does the patient pay for a companion or nurse?

- [ ] **A.** Before the visit (the estimate). Any difference is settled after.
- [ ] **B.** After the visit (the final amount). **← our default**
- [ ] **C.** A small advance at booking, the rest after.

**Our default:** B. Patients with an unpaid job must pay in advance next time.

**Changes in the app:** A or C protect against patients who book and then don't show up. B is simplest for patients.

**Client's answer:** 

### M4 — When the companion takes the patient to the hospital, who pays for the cab or auto?

- [ ] **A.** Patient pays the driver directly. **← our default**
- [ ] **B.** Companion pays, and it's added to the WellWish bill (with a receipt photo).
- [ ] **C.** Included in WellWish's per-km charge (companion uses their own vehicle).

**Our default:** A. Option C needs legal advice: carrying paying passengers in a private vehicle usually needs a commercial permit.

**Changes in the app:** Whether WellWish charges per km at all, and whether we need a reimbursement flow.

**Client's answer:** 

### M5 — During the visit, who pays hospital registration, tests and medicines?

- [ ] **A.** Patient or family pays the counter directly (UPI, card, cash). **← our default**
- [ ] **B.** Companion pays, then gets it back through the WellWish bill (up to a limit).

**Our default:** A

**Changes in the app:** B needs an advance and reimbursement flow, and puts the companion in charge of money.

**Client's answer:** 

### M6 — Is waiting time at the hospital charged by the hour? If the doctor is 2 hours late, who pays?

- [ ] **A.** Yes, per hour, and the patient pays for any delay. **← our default**
- [ ] **B.** Yes, but capped (e.g. after 4 hours, a flat rate).
- [ ] **C.** No. One fixed price per visit, so WellWish carries the risk.

**Our default:** A. The estimate screen shows the hourly rate clearly.

**Changes in the app:** The pricing formula.

**Client's answer:** 

## E. How WellWish earns

### E1 — Where does WellWish's income come from? (pick all that apply)

- [ ] **A.** Commission on companion and nurse jobs. **← our default**
- [ ] **B.** Booking fee from patients on doctor appointments. **← our default**
- [ ] **C.** Commission from doctors or hospitals on each booking.
- [ ] **D.** Membership plans. **← our default**
- [ ] **E.** Monthly listing fee from hospitals or doctors to appear in the app.

**Our default:** A + B + D. Family-member charges and part of cancellation fees also go to WellWish.

**Changes in the app:** Which fees exist in checkout, doctor contracts and the finance reports.

**Client's answer:** 

### E2 — How is the commission on companion and nurse jobs set?

- [ ] **A.** Same % on every service.
- [ ] **B.** Different % per service, changeable by admin. **← our default**
- [ ] **C.** Lower % for top-rated or busy partners (as a reward).

**Our default:** B. Companion 20%, nurse 20% to start.

**Changes in the app:** The partner-share field in price rules, and partner earnings.

**Client's answer:** 

### E3 — Who sets a partner's price?

- [ ] **A.** WellWish sets one price that applies to every partner. **← our default**
- [ ] **B.** Each partner sets their own rate, within a minimum and maximum set by admin.
- [ ] **C.** Price levels by experience (e.g. senior nurse costs more).

**Our default:** A. Levels (C) can be added later.

**Changes in the app:** With B or C, the nearby list shows different prices per partner and the estimate depends on who is chosen.

**Client's answer:** 

### E4 — Does the patient see WellWish's share inside one price, or as a separate fee?

- [ ] **A.** One total price. WellWish's 20% is inside it. **← our default**
- [ ] **B.** Partner's rate + a separate "platform fee" line on top.

**Our default:** A

**Changes in the app:** How bills and receipts are shown.

**Client's answer:** 

## S. Membership

### S1 — Does one membership cover one person or the whole family account?

- [ ] **A.** One person only.
- [ ] **B.** The whole account: owner + up to 5 family members. **← our default**

**Our default:** B

**Changes in the app:** Who gets member prices at checkout.

**Client's answer:** 

### S2 — For non-members, how are extra family members charged?

- [ ] **A.** Free, no limit.
- [ ] **B.** First 2 free, then a monthly fee per member. **← our default**
- [ ] **C.** One-time fee per member.

**Our default:** B. ₹49/month each after 2 free.

**Changes in the app:** Add-family-member flow and checkout.

**Client's answer:** 

### S3 — "Discount on Consultations": how does a member get it when the doctor's fee is paid at the hospital counter?

- [ ] **A.** Only on fees paid online in the app.
- [ ] **B.** Member's booking fee is waived (₹0 instead of ₹30). **← our default**
- [ ] **C.** Cashback as WellWish credit after the visit.

**Our default:** B

**Changes in the app:** Discount rules at checkout. C needs a patient wallet.

**Client's answer:** 

### S4 — Who pays for member discounts on companion and nurse jobs?

- [ ] **A.** WellWish only. The partner still gets 80% of the full price. **← our default**
- [ ] **B.** Shared between WellWish and the partner.

**Our default:** A. With 20% commission and 10% member discount, WellWish keeps only 10% on member bookings.

**Changes in the app:** Partner earnings and WellWish margin.

**Client's answer:** 

### S5 — Is there a limit on member discounts?

- [ ] **A.** No limit.
- [ ] **B.** Up to a number of discounted bookings per month. **← our default**
- [ ] **C.** Up to a rupee amount of discount per month.

**Our default:** B. 4 discounted bookings a month, so membership stays profitable (see the earnings example).

**Changes in the app:** Discount counter per member per month.

**Client's answer:** 

### S6 — Do the Monthly, Quarterly and Yearly plans give the same benefits?

- [ ] **A.** Same benefits. Longer plans are just cheaper per month. **← our default**
- [ ] **B.** Longer plans give extra benefits.

**Our default:** A. All plans auto-renew. Cancel any time, no refund, benefits stay until the period ends.

**Changes in the app:** Plan setup in the admin panel.

**Client's answer:** 

## D. Doctor appointments

### D1 — How does a WellWish booking reach the hospital, so the patient isn't turned away?

- [ ] **A.** Each doctor gives WellWish a fixed set of slots. Bookings are confirmed instantly. **← our default**
- [ ] **B.** Same slots as the hospital. The hospital desk confirms each booking before it's final.
- [ ] **C.** Live connection to the hospital's own software.

**Our default:** A. The doctor sees bookings in the Partner app, and admin sends each hospital the day's list.

**Changes in the app:** With B, bookings aren't instant. C is a large integration for every hospital.

**Client's answer:** 

### D2 — Does the patient get an exact time or a token number?

- [ ] **A.** Exact time (10:15).
- [ ] **B.** Session + token (Morning OPD, token 5).
- [ ] **C.** Set per doctor. **← our default**

**Our default:** C

**Changes in the app:** The time-slot screen and what the patient sees on the booking.

**Client's answer:** 

## C. Companion

### C1 — Who chooses the companion?

- [ ] **A.** WellWish assigns automatically.
- [ ] **B.** Patient picks one from the nearby list.
- [ ] **C.** Both: patient can pick, and WellWish assigns another if that one says no. **← our default**

**Our default:** C

**Changes in the app:** Booking screens and the job-assignment logic.

**Client's answer:** 

### C2 — The son booked from another city and the mother is at home. Who gives the companion the start OTP?

- [ ] **A.** OTP is also sent by SMS to the mother's own phone. **← our default**
- [ ] **B.** Companion calls the son, who reads out the OTP.
- [ ] **C.** Someone at home taps "Companion arrived" on their phone.

**Our default:** A

**Changes in the app:** The patient's own phone number becomes required for home pickups.

**Client's answer:** 

## N. Home nurse

### N1 — Who supplies medicines and nursing items (syringes, dressing kits, IV sets)?

- [ ] **A.** Family buys them before the visit. **← our default**
- [ ] **B.** Nurse brings a kit, and the cost is added to the bill.

**Our default:** A

**Changes in the app:** B adds item charges to the nurse bill.

**Client's answer:** 

### N2 — Is a doctor's prescription required before a nurse gives injections or IV? Who checks it?

- [ ] **A.** Required. The nurse checks it at the visit.
- [ ] **B.** Required. WellWish checks it before assigning a nurse. **← our default**
- [ ] **C.** Not required.

**Our default:** B

**Changes in the app:** A prescription upload step at booking and an admin check.

**Client's answer:** 

### N3 — A nurse records a dangerous reading (e.g. oxygen 89%). Who is alerted, and who acts?

- [ ] **A.** Family only.
- [ ] **B.** Family and the WellWish team. **← our default**
- [ ] **C.** Family, the WellWish team and the patient's doctor.

**Our default:** B. A doctor on the client's side should approve the alert limits.

**Changes in the app:** Health alert rules.

**Client's answer:** 

## P. Partners

### P1 — Are companions and nurses freelancers who can refuse jobs, or employees given fixed shifts?

- [ ] **A.** Freelancers. They go online when they want and can refuse jobs. **← our default**
- [ ] **B.** Employees. WellWish gives them shifts and jobs.

**Our default:** A

**Changes in the app:** The whole job-assignment logic, payouts and partner rules.

**Client's answer:** 

### P2 — Who controls a doctor's schedule and leave?

- [ ] **A.** WellWish admin only.
- [ ] **B.** The doctor only.
- [ ] **C.** Set per doctor: one of the two, never both. **← our default**

**Our default:** C

**Changes in the app:** Schedule editing in the Partner app and the admin panel.

**Client's answer:** 

## O. Cancellations and hours

### O1 — When a patient cancels late, what's the fee and who keeps it?

- [ ] **A.** WellWish keeps it.
- [ ] **B.** The partner keeps it, as compensation.
- [ ] **C.** Split between them. **← our default**

**Our default:** C. Free until 2 hours before. ₹50 after that. Base fare if the partner is already on the way.

**Changes in the app:** Cancellation fees and ledger entries.

**Client's answer:** 

### O2 — Are companion and nurse bookings available 24×7?

- [ ] **A.** Yes, 24×7.
- [ ] **B.** Fixed hours (e.g. 7 AM–9 PM). **← our default**

**Our default:** B. Nurse shifts can still run overnight. Someone from WellWish must be on duty for every booking hour.

**Changes in the app:** Booking time limits and who watches for problems.

**Client's answer:** 

## After the meeting

1. Send the client a written summary of the answers within 24 hours and ask them to confirm.
2. Update `ARCHITECTURE.md`: §6 logic, the money-flow and pricing rules, and §17 open decisions.
3. Then create the Kiran / Akash phase split in `docs/phases/`.
