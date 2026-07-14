<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<% request.setAttribute("pageTitle", "Loans"); request.setAttribute("activeNav", "loans"); %>
<jsp:include page="/WEB-INF/includes/app-header.jsp"/>

<div class="page-head">
  <div><h1 class="page-title">Loans</h1><p class="page-sub">Manage your loans and apply for new loans.</p></div>
  <div class="page-actions"><a class="btn btn-blue" href="#apply"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M12 5v14M5 12h14"/></svg> Apply for New Loan</a></div>
</div>

<div class="content-grid">
  <div class="grid">
    <c:if test="${not empty success}"><div class="alert-banner alert-ok"><c:out value="${success}"/></div></c:if>
    <c:if test="${not empty error}"><div class="alert-banner alert-error"><c:out value="${error}"/></div></c:if>

    <!-- Loan overview -->
    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Loan Overview</span></div>
      <div class="grid grid-4">
        <div class="srow" style="gap:12px"><span class="stat-ic ic-blue" style="width:44px;height:44px"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="6" width="18" height="12" rx="3"/><path d="M3 10h18"/></svg></span><div><div class="stat-label">Total Loans</div><div class="k-val" style="font-size:1.3rem">${loanCount}</div><div class="muted" style="font-size:.76rem">Active Loans</div></div></div>
        <div class="srow" style="gap:12px"><span class="stat-ic ic-green" style="width:44px;height:44px"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M4 7h16v10H4z"/><circle cx="12" cy="12" r="2.5"/></svg></span><div><div class="stat-label">Total Outstanding</div><div class="k-val" style="font-size:1.15rem">₹${totalOutstanding}</div><div class="muted" style="font-size:.76rem">Across All Loans</div></div></div>
        <div class="srow" style="gap:12px"><span class="stat-ic ic-purple" style="width:44px;height:44px"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="5" width="18" height="16" rx="3"/><path d="M3 9h18M8 3v4M16 3v4"/></svg></span><div><div class="stat-label">Total EMI Due</div><div class="k-val" style="font-size:1.15rem">₹${totalEmi}</div><div class="muted" style="font-size:.76rem">This Month</div></div></div>
        <div class="srow" style="gap:12px"><span class="stat-ic ic-amber" style="width:44px;height:44px"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 3a9 9 0 1 0 9 9h-9V3Z"/></svg></span><div><div class="stat-label">Total Paid</div><div class="k-val" style="font-size:1.15rem">₹${totalPaid}</div><div class="muted" style="font-size:.76rem">Till Date</div></div></div>
      </div>
    </div>

    <!-- Active loans -->
    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Your Active Loans</span></div>
      <c:choose>
        <c:when test="${empty loans}">
          <p class="muted" style="font-size:.9rem">You have no loans yet. Use the form below to apply for one.</p>
        </c:when>
        <c:otherwise>
          <c:forEach var="l" items="${loans}">
            <div class="srow" style="gap:16px">
              <span class="stat-ic ic-blue" style="width:46px;height:46px"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M3 10 12 4l9 6M5 10v9h14v-9"/></svg></span>
              <div style="min-width:130px"><div class="acct-name"><c:out value="${l.name}"/></div><div class="acct-num"><c:out value="${l.ref}"/></div></div>
              <div><div class="k-label">Outstanding</div><div class="k-val">₹${l.outstanding}</div></div>
              <div><div class="k-label">EMI Amount</div><div class="k-val">₹${l.emi}</div><div class="muted" style="font-size:.76rem">Next Due: ${l.nextDue}</div></div>
              <div style="flex:1;min-width:120px"><div class="limit-top"><span class="limit-name">Progress</span><span class="limit-val">${l.progress}%</span></div><div class="progress"><span style="width:${l.progress}%;background:#2563eb"></span></div></div>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>
      <div class="note-card" style="margin-top:16px">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3l7 3v5c0 5-3.5 8.5-7 10-3.5-1.5-7-5-7-10V6l7-3Z"/></svg>
        <div style="flex:1"><b style="color:var(--navy-900)">Pay your EMIs on time</b><div class="muted" style="font-size:.85rem">Timely EMI payments help maintain a good credit score and eligibility for better loan offers.</div></div>
        <a class="btn btn-ghost" href="#">Set Up AutoPay</a>
      </div>
    </div>

    <!-- Apply for a new loan -->
    <div class="card card-pad" id="apply">
      <div class="card-head"><span class="card-title">Apply for a New Loan</span></div>
      <form action="${pageContext.request.contextPath}/loans" method="post">
        <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}">
        <div class="grid grid-2" style="gap:0 20px">
          <div class="field"><label for="loanType">Loan Type</label>
            <select class="select" id="loanType" name="loanType" required>
              <option value="HOME">Home Loan</option>
              <option value="CAR">Car Loan</option>
              <option value="PERSONAL" selected>Personal Loan</option>
              <option value="EDUCATION">Education Loan</option>
            </select>
          </div>
          <div class="field"><label for="loanAmount">Loan Amount</label>
            <div class="input-group"><span class="lead-ic" style="font-weight:600">₹</span><input class="input" type="number" id="loanAmount" name="amount" min="10000" step="1000" placeholder="e.g., 500000" style="padding-left:34px" required></div>
          </div>
          <div class="field"><label for="loanRate">Interest Rate (% p.a.)</label>
            <input class="input" type="number" id="loanRate" name="rate" min="1" max="30" step="0.1" value="10.5" required>
          </div>
          <div class="field"><label for="loanTenure">Tenure (months)</label>
            <input class="input" type="number" id="loanTenure" name="tenureMonths" min="6" max="600" step="1" value="60" required>
          </div>
        </div>
        <button type="submit" class="btn btn-blue btn-lg btn-block" style="margin-top:8px">Submit Application</button>
      </form>
      <div class="note-strip" style="margin-top:16px">
        <div class="note"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M19 5 5 19M8 6a2 2 0 1 1-4 0 2 2 0 0 1 4 0ZM20 18a2 2 0 1 1-4 0 2 2 0 0 1 4 0Z"/></svg><div><b>Low Interest Rates</b><span>Attractive rates across loan types.</span></div></div>
        <div class="note"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M13 2 4 14h7l-1 8 9-12h-7l1-8Z"/></svg><div><b>Quick Approval</b><span>Instant approval, minimal documentation.</span></div></div>
        <div class="note"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 3l7 3v5c0 5-3.5 8.5-7 10-3.5-1.5-7-5-7-10V6l7-3Z"/></svg><div><b>Flexible Tenure</b><span>Choose a tenure that suits you.</span></div></div>
      </div>
    </div>
  </div>

  <!-- Rail -->
  <div class="grid">
    <div class="card card-pad">
      <div class="card-head"><span class="card-title">EMI Calculator</span></div>
      <div class="tabs"><span class="tab active">Home Loan</span><span class="tab">Car Loan</span><span class="tab">Personal Loan</span></div>
      <div class="field"><label>Loan Amount</label><div class="input-group"><span class="lead-ic" style="font-weight:600">₹</span><input class="input" value="10,00,000" style="padding-left:34px"></div>
        <input type="range" min="100000" max="50000000" value="10000000" style="width:100%;accent-color:var(--primary);margin-top:8px"><div class="limit-top"><span class="muted">₹1L</span><span class="muted">₹5Cr</span></div></div>
      <div class="field"><label>Interest Rate (% p.a.)</label><input class="input" value="8.50">
        <input type="range" min="5" max="20" value="8.5" step="0.1" style="width:100%;accent-color:var(--primary);margin-top:8px"><div class="limit-top"><span class="muted">5%</span><span class="muted">20%</span></div></div>
      <div class="field"><label>Loan Tenure</label><select class="select"><option>20 Years</option><option>15 Years</option><option>10 Years</option></select></div>
      <div style="display:flex;justify-content:space-between;align-items:center;padding-top:12px;border-top:1px solid var(--border)"><span class="muted">Estimated EMI</span><span style="font-family:var(--font-head);font-weight:700;font-size:1.3rem;color:var(--success)">₹8,775 <span class="muted" style="font-size:.8rem;font-weight:400">/month</span></span></div>
    </div>

    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Quick Actions</span></div>
      <div class="qa" style="grid-template-columns:repeat(3,1fr)">
        <a class="qa-item" href="#"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 5v14M5 12h14"/></svg></span><span class="qa-label">Apply for Loan</span></a>
        <a class="qa-item" href="#"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M7 3h7l4 4v14H7z"/><path d="M14 3v4h4"/></svg></span><span class="qa-label">Loan Statement</span></a>
        <a class="qa-item" href="#"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="4" y="3" width="16" height="18" rx="2"/><path d="M8 7h8M8 11h8M8 15h4"/></svg></span><span class="qa-label">EMI Calculator</span></a>
        <a class="qa-item" href="#"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="12" r="9"/><path d="M9 9l6 6M15 9l-6 6"/></svg></span><span class="qa-label">Foreclosure</span></a>
        <a class="qa-item" href="#"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></svg></span><span class="qa-label">Payment History</span></a>
        <a class="qa-item" href="#"><span class="qa-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M4 12a8 8 0 0 1 14-5M20 12a8 8 0 0 1-14 5"/><path d="M18 3v4h-4M6 21v-4h4"/></svg></span><span class="qa-label">Set Up AutoPay</span></a>
      </div>
    </div>

    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Important Links</span></div>
      <a class="srow" href="#"><div class="srow-body"><div class="srow-title">Interest Rates &amp; Charges</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
      <a class="srow" href="#"><div class="srow-body"><div class="srow-title">Loan Documentation</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
      <a class="srow" href="#"><div class="srow-body"><div class="srow-title">FAQs</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/includes/app-footer.jsp"/>
