<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<% request.setAttribute("pageTitle", "Pay Bills"); request.setAttribute("activeNav", "bills"); %>
<jsp:include page="/WEB-INF/includes/app-header.jsp"/>

<div class="page-head">
  <div><h1 class="page-title">Pay Bills</h1><p class="page-sub">Pay all your bills in one place instantly and securely.</p></div>
</div>

<div class="content-grid">
  <!-- Main -->
  <div class="grid">
    <c:if test="${not empty success}"><div class="alert-banner alert-ok"><c:out value="${success}"/></div></c:if>
    <c:if test="${not empty error}"><div class="alert-banner alert-error"><c:out value="${error}"/></div></c:if>

    <div class="card card-pad">
      <div class="card-head"><span class="card-title">1. Select a Bill Category</span></div>
      <div class="cat-grid" id="catGrid">
        <div class="cat active" data-cat="Electricity"><span class="cat-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M13 2 4 14h7l-1 8 9-12h-7l1-8Z"/></svg></span><span>Electricity</span></div>
        <div class="cat" data-cat="Mobile"><span class="cat-ic ic-purple"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="7" y="2" width="10" height="20" rx="2"/><path d="M11 18h2"/></svg></span><span>Mobile</span></div>
        <div class="cat" data-cat="DTH"><span class="cat-ic ic-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 20a12 12 0 0 1 12-12"/><path d="M4 14a6 6 0 0 1 6-6"/><circle cx="5" cy="19" r="1.4"/></svg></span><span>DTH</span></div>
        <div class="cat" data-cat="Water"><span class="cat-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3s6 7 6 11a6 6 0 0 1-12 0c0-4 6-11 6-11Z"/></svg></span><span>Water</span></div>
        <div class="cat" data-cat="Gas"><span class="cat-ic ic-amber"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3c1 3 4 4 4 8a4 4 0 0 1-8 0c0-1 .5-2 1-3 .5 2 2 2 2 2s-1-4 1-7Z"/></svg></span><span>Gas</span></div>
        <div class="cat" data-cat="Broadband"><span class="cat-ic ic-purple"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M5 13a10 10 0 0 1 14 0"/><path d="M8.5 16.5a5 5 0 0 1 7 0"/><circle cx="12" cy="20" r="1"/></svg></span><span>Broadband</span></div>
        <div class="cat" data-cat="Insurance"><span class="cat-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3l7 3v5c0 5-3.5 8.5-7 10-3.5-1.5-7-5-7-10V6l7-3Z"/></svg></span><span>Insurance</span></div>
      </div>
    </div>

    <div class="card card-pad">
      <div class="card-head"><span class="card-title">2. Enter Bill Details</span>
        <span class="muted" style="font-size:.82rem">Paying from A/c ${sessionScope.accountNo} &bull; Bal ₹${balance}</span></div>
      <form action="${pageContext.request.contextPath}/bills" method="post">
        <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}">
        <input type="hidden" name="category" id="categoryField" value="Electricity">
        <div class="grid grid-2" style="gap:0 20px">
          <div class="field"><label for="biller">Biller</label>
            <select class="select" id="biller" name="biller" required>
              <option value="">Select Biller</option>
              <option>TPSPDCL</option><option>BSES Rajdhani</option><option>Adani Electricity</option>
              <option>Jio</option><option>Airtel</option><option>Vodafone Idea</option>
              <option>Tata Play</option><option>BWSSB</option><option>Other</option>
            </select>
          </div>
          <div class="field"><label for="consumerNo">Consumer Number</label>
            <input class="input" type="text" id="consumerNo" name="consumerNo" maxlength="60" placeholder="Enter consumer / account number" required>
          </div>
          <div class="field"><label for="nickname">Nickname (Optional)</label><input class="input" type="text" id="nickname" name="nickname" maxlength="120" placeholder="e.g., Home Electricity"></div>
          <div class="field"><label for="amount">Amount</label>
            <div class="input-group"><span class="lead-ic" style="font-weight:600">₹</span><input class="input" type="number" id="amount" name="amount" min="1" step="0.01" placeholder="Enter amount" style="padding-left:34px" required></div>
            <div class="amt-chips"><span class="chip amt-chip">500</span><span class="chip amt-chip">1000</span><span class="chip amt-chip">2000</span></div>
          </div>
        </div>
        <button type="submit" class="btn btn-blue btn-lg btn-block" style="margin-top:8px">Proceed to Pay</button>
      </form>
    </div>

    <div class="card card-pad">
      <div class="note-strip">
        <div class="note"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3l7 3v5c0 5-3.5 8.5-7 10-3.5-1.5-7-5-7-10V6l7-3Z"/></svg><div><b>Secure Payments</b><span>Your payments are protected with bank-level security.</span></div></div>
        <div class="note"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M13 2 4 14h7l-1 8 9-12h-7l1-8Z"/></svg><div><b>Instant Confirmation</b><span>Receive instant confirmation for all bill payments.</span></div></div>
        <div class="note"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></svg><div><b>24/7 Availability</b><span>Pay your bills anytime, anywhere.</span></div></div>
      </div>
    </div>
  </div>

  <!-- Rail -->
  <div class="grid">
    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Bill Payment History</span><a class="card-link" href="${pageContext.request.contextPath}/transactions">View All</a></div>
      <c:choose>
        <c:when test="${empty history}">
          <p class="muted" style="font-size:.88rem">No bill payments yet. Pay your first bill to see it here.</p>
        </c:when>
        <c:otherwise>
          <c:forEach var="b" items="${history}">
            <div class="benef"><span class="tx-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M6 2h12v20l-3-2-3 2-3-2-3 2V2Z"/><path d="M9 7h6M9 11h6"/></svg></span>
              <div class="benef-body"><div class="benef-name"><c:out value="${b.category}"/> - <c:out value="${b.biller}"/></div><div class="benef-sub"><c:out value="${b.consumerNo}"/> &bull; ${b.date}</div></div>
              <div style="text-align:right"><div style="font-weight:700;color:var(--navy-900)">₹${b.amount}</div><span class="pill ${b.statusOk ? 'pill-green' : 'pill-rose'}">${b.statusOk ? 'Success' : 'Failed'}</span></div></div>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="card promo-card">
      <div>
        <h3 style="font-family:var(--font-head);color:var(--navy-900);font-size:1.15rem;font-weight:700">Set up AutoPay</h3>
        <p class="muted" style="margin:6px 0 14px;font-size:.88rem">Never miss a bill payment. Set up AutoPay and stay worry-free.</p>
        <a class="btn btn-ghost" href="#">Set Up AutoPay</a>
      </div>
      <svg width="88" height="88" viewBox="0 0 88 88" fill="none" aria-hidden="true"><rect x="16" y="20" width="56" height="52" rx="10" fill="#1e3a8a"/><rect x="16" y="20" width="56" height="16" rx="8" fill="#2563eb"/><circle cx="44" cy="52" r="12" fill="#fff"/><path d="M39 52l4 4 6-7" stroke="#2563eb" stroke-width="3" fill="none" stroke-linecap="round" stroke-linejoin="round"/></svg>
    </div>
  </div>
</div>

<script>
  (function () {
    var grid = document.getElementById('catGrid');
    var field = document.getElementById('categoryField');
    if (grid && field) {
      grid.addEventListener('click', function (e) {
        var cat = e.target.closest('.cat');
        if (!cat) return;
        grid.querySelectorAll('.cat').forEach(function (n) { n.classList.remove('active'); });
        cat.classList.add('active');
        field.value = cat.getAttribute('data-cat');
      });
    }
    var amount = document.getElementById('amount');
    document.querySelectorAll('.amt-chip').forEach(function (chip) {
      chip.style.cursor = 'pointer';
      chip.addEventListener('click', function () { if (amount) amount.value = chip.textContent.trim(); });
    });
  })();
</script>
<jsp:include page="/WEB-INF/includes/app-footer.jsp"/>
