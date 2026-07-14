<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<% request.setAttribute("pageTitle", request.getAttribute("mode")); request.setAttribute("activeNav", "accounts"); %>
<jsp:include page="/WEB-INF/includes/app-header.jsp"/>

<div class="page-head">
  <div><h1 class="page-title">${mode} Money</h1><p class="page-sub">${mode} funds to your account ${accountNo}</p></div>
  <div class="page-actions"><a class="btn btn-ghost" href="${pageContext.request.contextPath}/accounts">Back to Accounts</a></div>
</div>

<div style="max-width:560px">
  <div class="card card-pad">
    <c:if test="${not empty success}"><div class="alert-banner alert-ok"><c:out value="${success}"/></div></c:if>
    <c:if test="${not empty error}"><div class="alert-banner alert-error"><c:out value="${error}"/></div></c:if>

    <div class="stat-card" style="padding:0 0 18px">
      <span class="stat-ic ic-blue"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="2" y="5" width="20" height="14" rx="3"/><path d="M2 10h20"/></svg></span>
      <div><div class="stat-label">Available Balance</div><div class="stat-value">₹${balance}</div></div>
    </div>

    <form action="${pageContext.request.contextPath}/${action}" method="post">
      <input type="hidden" name="_csrf" value="${sessionScope.csrfToken}">
      <div class="field">
        <label for="amount">Amount to ${mode}</label>
        <div class="input-group">
          <span class="lead-ic" style="font-weight:600">₹</span>
          <input class="input" type="number" id="amount" name="amount" min="1" step="0.01" placeholder="Enter amount" style="padding-left:34px" required autofocus>
        </div>
        <div class="amt-chips"><span class="chip">₹500</span><span class="chip">₹1,000</span><span class="chip">₹5,000</span><span class="chip">₹10,000</span></div>
      </div>
      <button type="submit" class="btn ${action == 'deposit' ? 'btn-blue' : 'btn-navy'} btn-lg btn-block">${mode} Now</button>
    </form>
  </div>
</div>

<script>
  document.querySelectorAll('.chip').forEach(function (ch) {
    ch.addEventListener('click', function () {
      document.getElementById('amount').value = this.textContent.replace(/[₹,]/g, '');
    });
  });
</script>

<jsp:include page="/WEB-INF/includes/app-footer.jsp"/>
