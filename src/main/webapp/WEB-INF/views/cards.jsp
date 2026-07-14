<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<% request.setAttribute("pageTitle", "My Cards"); request.setAttribute("activeNav", "cards"); %>
<jsp:include page="/WEB-INF/includes/app-header.jsp"/>

<div class="page-head">
  <div><h1 class="page-title">My Cards</h1><p class="page-sub">Manage your debit and credit cards, set limits and control usage.</p></div>
  <div class="page-actions"><a class="btn btn-blue" href="#"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M12 5v14M5 12h14"/></svg> Apply New Card</a></div>
</div>

<div class="content-grid">
  <div class="grid">
    <!-- Cards carousel -->
    <div class="card card-pad">
      <div class="tabs"><span class="tab active">All Cards</span><span class="tab">Debit Cards</span><span class="tab">Credit Cards</span></div>
      <div style="display:flex;gap:22px;flex-wrap:wrap;justify-content:center">
        <c:choose>
          <c:when test="${empty cards}">
            <div class="muted" style="padding:24px">No cards issued yet.</div>
          </c:when>
          <c:otherwise>
            <c:forEach var="cd" items="${cards}">
              <div>
                <div class="bankcard ${cd.variant}">
                  <div class="bc-top"><span>AceBank</span><span class="bc-type">${cd.type}</span></div>
                  <button class="chip" aria-hidden="true"></button>
                  <div class="bc-num"><c:out value="${cd.masked}"/></div>
                  <div class="bc-foot"><span><c:out value="${cd.holder}"/></span><span>VALID ${cd.expiry}</span><b style="font-style:italic">${cd.network}</b></div>
                </div>
                <div style="text-align:center;margin-top:10px">
                  <span style="font-weight:600;color:var(--navy-900);font-size:.9rem">${cd.type == 'CREDIT' ? 'Credit Card' : 'Debit Card'}</span>
                  <span class="pill ${cd.statusClass}">${cd.status}</span>
                </div>
              </div>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </div>
      <div class="card-dots"><i class="on"></i><i></i><i></i><i></i></div>
    </div>

    <!-- Card controls -->
    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Card Controls</span></div>
      <div class="ctrl-grid">
        <div class="ctrl"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="10" width="16" height="11" rx="2"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/></svg><b>Block Card</b><span>Temporarily block your card</span></div>
        <div class="ctrl"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><path d="M12 3v9l6 3"/></svg><b>Set Limits</b><span>Manage spending limits</span></div>
        <div class="ctrl"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="8" width="20" height="8" rx="4"/><circle cx="16" cy="12" r="3" fill="currentColor"/></svg><b>Enable/Disable</b><span>Enable or disable online usage</span></div>
        <div class="ctrl"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="10" width="16" height="11" rx="2"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/><circle cx="12" cy="15" r="1.5"/></svg><b>Change PIN</b><span>Set or reset your card PIN</span></div>
        <div class="ctrl"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="5" width="20" height="14" rx="3"/><path d="M2 10h20"/><path d="M18 15h2"/></svg><b>Request New Card</b><span>Get a new physical or virtual card</span></div>
      </div>
    </div>

    <!-- Spending overview -->
    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Spending Overview</span><select class="select" style="width:auto"><option>This Month</option></select></div>
      <div style="display:flex;align-items:center;gap:28px;flex-wrap:wrap">
        <div class="donut" style="background:conic-gradient(#2563eb 0 34%, #7c3aed 34% 56%, #f59e0b 56% 76%, #10b981 76% 87%, #cbd5e1 87% 100%)">
          <div class="donut-center"><div style="font-family:var(--font-head);font-weight:700;font-size:1.25rem;color:var(--navy-900)">₹18,750</div><div class="muted" style="font-size:.72rem">Total Spent</div></div>
        </div>
        <ul class="legend" style="flex:1;min-width:220px">
          <li><span><span class="dot" style="background:#2563eb"></span>Shopping</span><span>₹6,450 (34%)</span></li>
          <li><span><span class="dot" style="background:#7c3aed"></span>Dining</span><span>₹4,200 (22%)</span></li>
          <li><span><span class="dot" style="background:#f59e0b"></span>Travel</span><span>₹3,800 (20%)</span></li>
          <li><span><span class="dot" style="background:#10b981"></span>Entertainment</span><span>₹2,150 (11%)</span></li>
          <li><span><span class="dot" style="background:#cbd5e1"></span>Others</span><span>₹2,150 (13%)</span></li>
        </ul>
      </div>
    </div>
  </div>

  <!-- Rail -->
  <div class="grid">
    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Card Summary</span><a class="card-link" href="#">View Details</a></div>
      <div class="grid grid-2" style="gap:14px">
        <div><div class="k-label">Total Card Limit</div><div class="k-val">₹2,00,000.00</div></div>
        <div><div class="k-label">Available Limit</div><div class="k-val">₹1,28,750.00</div></div>
      </div>
      <div class="progress" style="margin:14px 0"><span style="width:64%"></span></div>
      <div class="grid grid-2" style="gap:14px">
        <div><div class="k-label">Total Outstanding</div><div class="k-val">₹31,250.00</div></div>
        <div><div class="k-label">Next Due Date</div><div class="k-val">15 Jun 2025</div></div>
      </div>
      <a class="btn btn-ghost btn-block" href="#" style="margin-top:16px">Pay Credit Card Bill</a>
    </div>

    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Recent Transactions</span><a class="card-link" href="#">View All</a></div>
      <div class="benef"><span class="tx-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="9" cy="21" r="1"/><circle cx="18" cy="21" r="1"/><path d="M3 4h2l2 12h11l2-8H6"/></svg></span><div class="benef-body"><div class="benef-name">Amazon.in</div><div class="benef-sub">31 May 2025, 08:45 PM</div></div><div style="font-weight:700;color:var(--navy-900)">₹2,499.00</div></div>
      <div class="benef"><span class="tx-ic ic-rose"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M5 8h14l-1 13H6L5 8Z"/></svg></span><div class="benef-body"><div class="benef-name">Swiggy</div><div class="benef-sub">30 May 2025, 07:21 PM</div></div><div style="font-weight:700;color:var(--navy-900)">₹650.00</div></div>
      <div class="benef"><span class="tx-ic ic-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="6" width="18" height="12" rx="3"/></svg></span><div class="benef-body"><div class="benef-name">Uber</div><div class="benef-sub">30 May 2025, 01:15 PM</div></div><div style="font-weight:700;color:var(--navy-900)">₹875.00</div></div>
    </div>

    <div class="note-card">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3l7 3v5c0 5-3.5 8.5-7 10-3.5-1.5-7-5-7-10V6l7-3Z"/></svg>
      <div><b style="color:var(--blue-600)">Your Card is Secure</b><div class="muted" style="font-size:.85rem">We monitor your card 24/7 to detect any suspicious activity.</div></div>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/includes/app-footer.jsp"/>
