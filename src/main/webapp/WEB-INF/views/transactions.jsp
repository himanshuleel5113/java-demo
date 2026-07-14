<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<% request.setAttribute("pageTitle", "Transactions"); request.setAttribute("activeNav", "transactions"); %>
<jsp:include page="/WEB-INF/includes/app-header.jsp"/>

<div class="page-head">
  <div><h1 class="page-title">Transactions</h1><p class="page-sub">All activity on account ${primaryMasked}</p></div>
  <div class="page-actions"><a class="btn btn-ghost" href="${pageContext.request.contextPath}/dashboard">Back to Dashboard</a></div>
</div>

<div class="content-grid">
  <div class="card card-pad">
    <div class="card-head"><span class="card-title">Statement</span><span class="muted">${txCount} transactions</span></div>
    <c:choose>
      <c:when test="${empty txRows}">
        <div class="muted" style="padding:24px 0;text-align:center">No transactions yet.</div>
      </c:when>
      <c:otherwise>
        <div style="overflow-x:auto">
          <table class="table">
            <thead><tr><th>Date &amp; Time</th><th>Description</th><th>Type</th><th>Amount</th></tr></thead>
            <tbody>
              <c:forEach var="t" items="${txRows}">
                <tr>
                  <td><c:out value="${t.date}"/><div class="muted" style="font-size:.76rem"><c:out value="${t.ref}"/></div></td>
                  <td><b style="color:var(--navy-900)"><c:out value="${t.desc}"/></b></td>
                  <td><c:choose><c:when test="${t.credit}"><span class="up">↑ Credit</span></c:when><c:otherwise><span class="down">↓ Debit</span></c:otherwise></c:choose></td>
                  <td class="${t.credit ? 'amt-pos' : 'amt-neg'}"><c:out value="${t.amount}"/></td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </c:otherwise>
    </c:choose>
  </div>

  <div class="grid">
    <div class="card card-pad">
      <div class="card-head"><span class="card-title">Summary</span></div>
      <div class="benef"><span class="tx-ic ic-green"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 19V5M5 12l7-7 7 7"/></svg></span><div class="benef-body"><div class="benef-name" style="font-weight:500">Total Credits</div></div><div class="amt-pos"><c:out value="${totalCredits}"/></div></div>
      <div class="benef"><span class="tx-ic ic-rose"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 5v14M5 12l7 7 7-7"/></svg></span><div class="benef-body"><div class="benef-name" style="font-weight:500">Total Debits</div></div><div class="down" style="font-weight:700"><c:out value="${totalDebits}"/></div></div>
      <div class="benef"><span class="tx-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M4 8h13l-3-3M20 16H7l3 3"/></svg></span><div class="benef-body"><div class="benef-name" style="font-weight:500">Net</div></div><div class="amt-pos"><c:out value="${netBalance}"/></div></div>
    </div>

    <div class="note-card">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 13v-1a8 8 0 0 1 16 0v1"/><rect x="3" y="13" width="4" height="7" rx="2"/><rect x="17" y="13" width="4" height="7" rx="2"/></svg>
      <div><b style="color:var(--navy-900)">Need Help?</b><div class="muted" style="font-size:.85rem">Don't recognize a transaction? Report it.</div><a class="link" href="${pageContext.request.contextPath}/help" style="font-size:.85rem">Report an Issue</a></div>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/includes/app-footer.jsp"/>
