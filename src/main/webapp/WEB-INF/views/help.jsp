<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<% request.setAttribute("pageTitle", "Help & Support"); request.setAttribute("activeNav", "help"); %>
<jsp:include page="/WEB-INF/includes/app-header.jsp"/>

<div class="page-head">
  <div><h1 class="page-title">How can we help you?</h1><p class="page-sub">Find answers, contact support, or track your requests.</p></div>
</div>

<div class="content-grid">
  <div class="grid">
    <c:if test="${not empty success}"><div class="alert-banner alert-ok"><c:out value="${success}"/></div></c:if>
    <c:if test="${not empty error}"><div class="alert-banner alert-error"><c:out value="${error}"/></div></c:if>

    <div class="input-group">
      <span class="lead-ic"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"><circle cx="11" cy="11" r="7"/><path d="m21 21-4-4"/></svg></span>
      <input class="input" placeholder="Search for help articles, topics or keywords...">
    </div>

    <div class="grid grid-4">
      <div class="card card-pad"><span class="stat-ic ic-blue" style="margin-bottom:12px"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M4 5a2 2 0 0 1 2-2h6v18H6a2 2 0 0 1-2-2V5Z"/><path d="M12 3h6a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-6"/></svg></span><div class="card-title" style="font-size:1.05rem">FAQs</div><p class="muted" style="font-size:.86rem;margin:6px 0 14px">Find answers to common questions</p><a class="link" href="#">View FAQs →</a></div>
      <div class="card card-pad"><span class="stat-ic ic-green" style="margin-bottom:12px"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M21 12a8 8 0 0 1-11.5 7.2L4 21l1.8-5.5A8 8 0 1 1 21 12Z"/></svg></span><div class="card-title" style="font-size:1.05rem">Live Chat</div><p class="muted" style="font-size:.86rem;margin:6px 0 14px">Chat with our support executive</p><a class="link" href="#">Start Chat →</a></div>
      <div class="card card-pad"><span class="stat-ic ic-purple" style="margin-bottom:12px"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M4 5c0 9 6 15 15 15l1-4-5-2-2 2a11 11 0 0 1-5-5l2-2-2-5-4 1Z"/></svg></span><div class="card-title" style="font-size:1.05rem">Call Us</div><p class="muted" style="font-size:.86rem;margin:6px 0 14px">Speak with our support team</p><a class="link" href="#">Call Now →</a></div>
      <div class="card card-pad" style="background:#fff8ee;border-color:#fde9c8"><span class="stat-ic ic-amber" style="margin-bottom:12px"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="5" width="18" height="14" rx="2"/><path d="m3 7 9 6 9-6"/></svg></span><div class="card-title" style="font-size:1.05rem">Email Us</div><p class="muted" style="font-size:.86rem;margin:6px 0 14px">Send us an email and we'll reply</p><a class="link" style="color:#d97706" href="#">Send Email →</a></div>
    </div>

    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Raise a New Request</span></div>
      <form action="${pageContext.request.contextPath}/help" method="post">
        <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}">
        <div class="grid grid-2" style="gap:0 20px">
          <div class="field"><label for="subject">Subject</label>
            <input class="input" type="text" id="subject" name="subject" maxlength="160" placeholder="Briefly describe your issue" required></div>
          <div class="field"><label for="category">Category</label>
            <select class="select" id="category" name="category">
              <option>Transactions</option><option>Accounts</option><option>Cards</option>
              <option>Profile</option><option selected>Other</option>
            </select>
          </div>
        </div>
        <div class="field"><label for="message">Details (Optional)</label>
          <textarea class="input" id="message" name="message" rows="3" maxlength="1000" placeholder="Add any details that will help us assist you"></textarea></div>
        <button type="submit" class="btn btn-blue btn-lg">Submit Request</button>
      </form>
    </div>

    <div class="card card-pad">
      <div class="card-head"><span class="card-title">My Support Requests</span><a class="btn btn-ghost" href="#subject" style="padding:.5rem 1rem">+ New Request</a></div>
      <div style="overflow-x:auto">
        <table class="table">
          <thead><tr><th>Request ID</th><th>Subject</th><th>Category</th><th>Status</th><th>Last Updated</th></tr></thead>
          <tbody>
            <c:choose>
              <c:when test="${empty requests}">
                <tr><td colspan="5" class="muted" style="text-align:center;padding:18px">No support requests yet.</td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="r" items="${requests}">
                  <tr>
                    <td><c:out value="${r.ticket}"/></td>
                    <td><c:out value="${r.subject}"/></td>
                    <td><span class="pill pill-blue"><c:out value="${r.category}"/></span></td>
                    <td><span class="pill ${r.statusClass}"><c:out value="${r.status}"/></span></td>
                    <td>${r.updated}</td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </div>

    <div class="note-card">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3l7 3v5c0 5-3.5 8.5-7 10-3.5-1.5-7-5-7-10V6l7-3Z"/></svg>
      <div style="flex:1"><b style="color:var(--blue-600)">Your security is our priority</b><div class="muted" style="font-size:.85rem">Never share your OTP, PIN, password or CVV with anyone.</div></div>
      <a class="btn btn-ghost" href="#">Security Tips</a>
    </div>
  </div>

  <!-- Rail -->
  <div class="grid">
    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Popular Help Topics</span></div>
      <a class="srow" href="#"><div class="srow-body"><div class="srow-title" style="font-weight:500">How to reset your password</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
      <a class="srow" href="#"><div class="srow-body"><div class="srow-title" style="font-weight:500">How to add a beneficiary</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
      <a class="srow" href="#"><div class="srow-body"><div class="srow-title" style="font-weight:500">Fund transfer limits &amp; charges</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
      <a class="srow" href="#"><div class="srow-body"><div class="srow-title" style="font-weight:500">How to download statement</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
      <a class="srow" href="#"><div class="srow-body"><div class="srow-title" style="font-weight:500">Report unauthorized transaction</div></div><span class="chev"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 6 6 6-6 6"/></svg></span></a>
      <div style="text-align:center;margin-top:12px"><a class="link" href="#">View All Articles</a></div>
    </div>

    <div class="card card-pad" style="background:linear-gradient(120deg,#eef4ff,#f6f9ff);border-color:#e2ebff">
      <div class="card-title" style="font-size:1.05rem">Help Center</div>
      <p class="muted" style="font-size:.88rem;margin:8px 0 14px">We're here 24/7 to help you with all your banking needs.</p>
      <a class="btn btn-blue" href="#">Chat Now</a>
    </div>

    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Contact Information</span></div>
      <div class="benef"><span class="tx-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M4 5c0 9 6 15 15 15l1-4-5-2-2 2a11 11 0 0 1-5-5l2-2-2-5-4 1Z"/></svg></span><div class="benef-body"><div class="benef-sub">Customer Care Number</div><div class="benef-name" style="color:var(--blue-600)">1800 123 4567 (Toll Free)</div></div></div>
      <div class="benef"><span class="tx-ic ic-purple"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="5" width="18" height="14" rx="2"/><path d="m3 7 9 6 9-6"/></svg></span><div class="benef-body"><div class="benef-sub">Email Support</div><div class="benef-name" style="color:var(--blue-600)">support@acebank.com</div></div></div>
      <div class="benef"><span class="tx-ic ic-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></svg></span><div class="benef-body"><div class="benef-sub">Service Timings</div><div class="benef-name">24/7 - All Days</div></div></div>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/includes/app-footer.jsp"/>
