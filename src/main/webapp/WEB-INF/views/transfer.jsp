<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<% request.setAttribute("pageTitle", "Transfer Money"); request.setAttribute("activeNav", "transfer"); %>
<jsp:include page="/WEB-INF/includes/app-header.jsp"/>

<div class="page-head">
  <div><h1 class="page-title">Transfer Money</h1><p class="page-sub">Send money to your own account or other bank account</p></div>
</div>

<div class="content-grid">
  <!-- Main: transfer form -->
  <div class="grid">
    <div class="card card-pad">
      <div class="tabs">
        <span class="tab active">Within AceBank</span>
        <span class="tab">Other Bank (NEFT/RTGS/IMPS)</span>
        <span class="tab">UPI Transfer</span>
      </div>

      <c:if test="${not empty success}"><div class="alert-banner alert-ok"><c:out value="${success}"/></div></c:if>
      <c:if test="${not empty error}"><div class="alert-banner alert-error"><c:out value="${error}"/></div></c:if>

      <form action="${pageContext.request.contextPath}/transfer" method="post">
        <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}">
        <div class="field">
          <label>From Account</label>
          <select class="select" disabled>
            <option>Savings Account &middot; ${fromAccountNo} &nbsp;&bull;&nbsp; Available Balance: &#8377;${fromBalance}</option>
          </select>
        </div>

        <div class="field">
          <label for="toAccount">To Account</label>
          <div class="input-group">
            <input class="input" type="text" id="toAccount" name="toAccount" inputmode="numeric" placeholder="Enter account number or select beneficiary" required>
            <button type="button" class="trail-btn" aria-label="Pick beneficiary"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 4-6 8-6s8 2 8 6"/></svg></button>
          </div>
          <a class="link" href="#" style="display:inline-block;margin-top:8px">+ Add New Beneficiary</a>
        </div>

        <div class="field">
          <label for="amount">Amount</label>
          <div class="input-group">
            <span class="lead-ic" style="font-weight:600">₹</span>
            <input class="input" type="number" id="amount" name="amount" min="1" step="0.01" placeholder="Enter amount" style="padding-left:34px" required>
          </div>
          <div class="amt-chips"><span class="chip">₹500</span><span class="chip">₹1,000</span><span class="chip">₹5,000</span><span class="chip">₹10,000</span></div>
        </div>

        <div class="field">
          <label for="remarks">Remarks (Optional)</label>
          <input class="input" type="text" id="remarks" name="remarks" maxlength="255" placeholder="Enter remarks">
        </div>

        <button type="submit" class="btn btn-blue btn-lg btn-block">Continue to Transfer</button>
      </form>
    </div>

    <div class="note-card">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3l7 3v5c0 5-3.5 8.5-7 10-3.5-1.5-7-5-7-10V6l7-3Z"/><path d="M9.5 12l1.8 1.8L15 10"/></svg>
      <div><b style="color:var(--navy-900)">Your transactions are secure and encrypted</b><div class="muted" style="font-size:.85rem">We do not store your beneficiary account details.</div></div>
    </div>
  </div>

  <!-- Rail -->
  <div class="grid">
    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Saved Beneficiaries</span><a class="card-link" href="#">View All</a></div>
      <div class="benef"><span class="avatar" style="background:#eef2ff;color:#4f46e5">RS</span><div class="benef-body"><div class="benef-name">Rohan Sharma</div><div class="benef-sub">**** 3456</div></div><button class="dots">•••</button></div>
      <div class="benef"><span class="avatar" style="background:#ecfdf5;color:#059669">PV</span><div class="benef-body"><div class="benef-name">Priyo Verma</div><div class="benef-sub">**** 5678</div></div><button class="dots">•••</button></div>
      <div class="benef"><span class="avatar" style="background:#fff7ed;color:#d97706">AK</span><div class="benef-body"><div class="benef-name">Amit Kumar</div><div class="benef-sub">**** 9876</div></div><button class="dots">•••</button></div>
      <div class="benef"><span class="avatar" style="background:#eff6ff;color:#2563eb">SM</span><div class="benef-body"><div class="benef-name">Sneha Mehta</div><div class="benef-sub">**** 4321</div></div><button class="dots">•••</button></div>
      <a class="btn btn-ghost btn-block" href="#" style="margin-top:14px">+ Add New Beneficiary</a>
    </div>

    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Recent Transfers</span><a class="card-link" href="#">View All</a></div>
      <div class="benef"><span class="avatar" style="background:#eef2ff;color:#4f46e5">RS</span><div class="benef-body"><div class="benef-name">Rohan Sharma</div><div class="benef-sub">01 Jun 2025, 09:30 AM</div></div><div style="text-align:right"><div class="amt-pos">₹5,000.00</div><span class="pill pill-green">Success</span></div></div>
      <div class="benef"><span class="avatar" style="background:#ecfdf5;color:#059669">PV</span><div class="benef-body"><div class="benef-name">Priyo Verma</div><div class="benef-sub">31 May 2025, 04:15 PM</div></div><div style="text-align:right"><div class="amt-pos">₹2,500.00</div><span class="pill pill-green">Success</span></div></div>
      <div class="benef"><span class="avatar" style="background:#fff7ed;color:#d97706">AK</span><div class="benef-body"><div class="benef-name">Amit Kumar</div><div class="benef-sub">30 May 2025, 11:20 AM</div></div><div style="text-align:right"><div class="amt-pos">₹1,000.00</div><span class="pill pill-green">Success</span></div></div>
    </div>

    <div class="note-card">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3l7 3v5c0 5-3.5 8.5-7 10-3.5-1.5-7-5-7-10V6l7-3Z"/></svg>
      <div><b style="color:var(--blue-600)">Safe &amp; Secure Transfers</b><div class="muted" style="font-size:.85rem">AceBank ensures your money reaches safely with 256-bit encryption.</div></div>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/includes/app-footer.jsp"/>
