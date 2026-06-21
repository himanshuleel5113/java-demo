<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.math.RoundingMode" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.time.Instant" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.ZoneId" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.function.Function" %>
<%@ page import="com.acebank.lite.models.Transaction" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    String firstName = (String) session.getAttribute("firstName");
    String lastName = (String) session.getAttribute("lastName");
    String email = (String) session.getAttribute("email");
    BigDecimal balance = (BigDecimal) session.getAttribute("balance");
    List<Transaction> transactions = (List<Transaction>) session.getAttribute("transactionDetailsList");

    if (accountNumber == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }

    String contextPath = request.getContextPath();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");
    DateTimeFormatter shortDateFormatter = DateTimeFormatter.ofPattern("dd MMM");

    String fullAccountNumber = accountNumber.toString();
    String hiddenAccountNumber = "XXXX" + (fullAccountNumber.length() > 4
            ? fullAccountNumber.substring(fullAccountNumber.length() - 4)
            : fullAccountNumber);

    String customerName = ((firstName != null ? firstName : "") + " " + (lastName != null ? lastName : "")).trim();
    if (customerName.isEmpty()) {
        customerName = "Customer";
    }

    Function<Integer, String> maskAccount = acc -> {
        if (acc == null) {
            return "XXXX";
        }
        String value = acc.toString();
        return "XXXX" + (value.length() > 4 ? value.substring(value.length() - 4) : value);
    };

    List<Transaction> recentTransactions = new ArrayList<>();
    if (transactions != null) {
        recentTransactions.addAll(transactions);
    }
    recentTransactions.sort((left, right) -> {
        LocalDateTime leftTime = left != null ? left.createdAt() : null;
        LocalDateTime rightTime = right != null ? right.createdAt() : null;
        if (leftTime == null && rightTime == null) return 0;
        if (leftTime == null) return 1;
        if (rightTime == null) return -1;
        return rightTime.compareTo(leftTime);
    });

    BigDecimal totalCredits = BigDecimal.ZERO;
    BigDecimal totalDebits = BigDecimal.ZERO;

    BigDecimal recentCredits = BigDecimal.ZERO;
    BigDecimal previousCredits = BigDecimal.ZERO;
    BigDecimal recentDebits = BigDecimal.ZERO;
    BigDecimal previousDebits = BigDecimal.ZERO;

    List<BigDecimal> trendValues = new ArrayList<>();
    List<String> trendLabels = new ArrayList<>();

    for (int i = 0; i < recentTransactions.size(); i++) {
        Transaction transaction = recentTransactions.get(i);
        if (transaction == null) {
            continue;
        }
        BigDecimal amount = transaction.amount() != null ? transaction.amount() : BigDecimal.ZERO;
        String txType = transaction.txType() != null ? transaction.txType().toUpperCase() : "";
        boolean sentByThisAccount = transaction.senderAccount() != null && transaction.senderAccount().equals(accountNumber);
        boolean isCredit = "DEPOSIT".equals(txType) || "LOAN".equals(txType) || ("TRANSFER".equals(txType) && !sentByThisAccount);

        if (isCredit) {
            totalCredits = totalCredits.add(amount);
        } else {
            totalDebits = totalDebits.add(amount);
        }

        if (i < 5) {
            if (isCredit) {
                recentCredits = recentCredits.add(amount);
            } else {
                recentDebits = recentDebits.add(amount);
            }
        } else if (i < 10) {
            if (isCredit) {
                previousCredits = previousCredits.add(amount);
            } else {
                previousDebits = previousDebits.add(amount);
            }
        }

        if (trendValues.size() < 7) {
            trendValues.add(amount);
            trendLabels.add(transaction.createdAt() != null ? shortDateFormatter.format(transaction.createdAt()) : "-");
        }
    }

    BigDecimal maxTrendAmount = BigDecimal.ONE;
    for (BigDecimal value : trendValues) {
        if (value != null && value.compareTo(maxTrendAmount) > 0) {
            maxTrendAmount = value;
        }
    }

    double creditChange;
    if (previousCredits.compareTo(BigDecimal.ZERO) == 0) {
        creditChange = recentCredits.compareTo(BigDecimal.ZERO) > 0 ? 100.0 : 0.0;
    } else {
        creditChange = recentCredits.subtract(previousCredits)
                .multiply(new BigDecimal("100"))
                .divide(previousCredits, 2, RoundingMode.HALF_UP)
                .doubleValue();
    }

    double debitChange;
    if (previousDebits.compareTo(BigDecimal.ZERO) == 0) {
        debitChange = recentDebits.compareTo(BigDecimal.ZERO) > 0 ? 100.0 : 0.0;
    } else {
        debitChange = recentDebits.subtract(previousDebits)
                .multiply(new BigDecimal("100"))
                .divide(previousDebits, 2, RoundingMode.HALF_UP)
                .doubleValue();
    }

    int transactionCount = recentTransactions.size();
    BigDecimal netFlow = totalCredits.subtract(totalDebits);
    boolean lowBalance = balance == null || balance.compareTo(new BigDecimal("5000")) < 0;
    String healthLabel = lowBalance ? "Needs attention" : "Healthy";
    String healthCopy = lowBalance
            ? "Keep your balance above the daily comfort threshold for seamless withdrawals."
            : "Your balance is in a healthy range for regular transactions.";

    Transaction latestTransaction = recentTransactions.isEmpty() ? null : recentTransactions.get(0);
    String latestActivityLabel = (latestTransaction != null && latestTransaction.createdAt() != null)
            ? formatter.format(latestTransaction.createdAt())
            : "No recent activity";

    String latestActivitySummary;
    if (latestTransaction == null) {
        latestActivitySummary = "Start with a deposit or transfer to build transaction insights.";
    } else {
        String txType = latestTransaction.txType() != null ? latestTransaction.txType() : "ACTIVITY";
        BigDecimal amount = latestTransaction.amount() != null ? latestTransaction.amount() : BigDecimal.ZERO;
        latestActivitySummary = txType + " • ₹ " + String.format("%,.2f", amount);
    }

    String flashMessage = request.getParameter("msg");
    String flashError = request.getParameter("error");
    boolean hasFlash = (flashMessage != null && !flashMessage.isBlank()) || (flashError != null && !flashError.isBlank());
    boolean isErrorFlash = flashError != null && !flashError.isBlank();
    String rawFlashText = isErrorFlash ? flashError : flashMessage;
    String flashText = rawFlashText != null ? URLDecoder.decode(rawFlashText, StandardCharsets.UTF_8) : "";
    boolean showIncreaseLimitAction = isErrorFlash && flashText.toLowerCase().contains("daily withdrawal limit");

    LocalDateTime sessionStart = LocalDateTime.ofInstant(Instant.ofEpochMilli(session.getCreationTime()), ZoneId.systemDefault());
    String sessionStartText = formatter.format(sessionStart);
    String userAgent = request.getHeader("User-Agent");
    String deviceLabel = "Unknown device";
    if (userAgent != null) {
        String ua = userAgent.toLowerCase();
        if (ua.contains("windows")) {
            deviceLabel = "Windows device";
        } else if (ua.contains("android")) {
            deviceLabel = "Android device";
        } else if (ua.contains("iphone") || ua.contains("ios")) {
            deviceLabel = "iPhone device";
        } else if (ua.contains("mac")) {
            deviceLabel = "Mac device";
        }
    }
    String remoteAddress = request.getRemoteAddr() != null ? request.getRemoteAddr() : "IP unavailable";
%>
<jsp:include page="/includes/header.jsp" />

<div id="dashboardSkeleton" class="space-y-4">
    <div class="h-28 animate-pulse rounded-2xl bg-slate-200"></div>
    <div class="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
        <div class="h-24 animate-pulse rounded-2xl bg-slate-200"></div>
        <div class="h-24 animate-pulse rounded-2xl bg-slate-200"></div>
        <div class="h-24 animate-pulse rounded-2xl bg-slate-200"></div>
        <div class="h-24 animate-pulse rounded-2xl bg-slate-200"></div>
    </div>
    <div class="h-56 animate-pulse rounded-2xl bg-slate-200"></div>
</div>

<div id="dashboardContent" class="hidden space-y-6 pb-8">
    <% if (hasFlash) { %>
        <div class="rounded-xl border px-4 py-3 shadow-sm <%= isErrorFlash ? "border-rose-200 bg-rose-50 text-rose-800" : "border-emerald-200 bg-emerald-50 text-emerald-800" %>">
            <div class="flex flex-wrap items-center justify-between gap-3">
                <div class="flex items-start gap-3">
                    <div class="mt-0.5 flex h-8 w-8 items-center justify-center rounded-lg <%= isErrorFlash ? "bg-rose-100" : "bg-emerald-100" %>">
                        <i class="fas <%= isErrorFlash ? "fa-circle-exclamation" : "fa-circle-check" %> text-sm"></i>
                    </div>
                    <div>
                        <p class="text-sm font-semibold"><%= isErrorFlash ? "Action needs attention" : "Action completed" %></p>
                        <p class="text-sm"><%= flashText %></p>
                    </div>
                </div>
                <% if (showIncreaseLimitAction) { %>
                    <a href="<%= contextPath %>/Loan.jsp" class="inline-flex items-center rounded-lg border border-rose-300 bg-white px-3 py-1.5 text-xs font-semibold text-rose-700 transition hover:bg-rose-100">
                        Increase Limit
                    </a>
                <% } %>
            </div>
        </div>
    <% } %>

    <!-- Balance First -->
    <section class="rounded-2xl bg-gradient-to-r from-blue-900 to-slate-900 px-6 py-6 text-white shadow-md">
        <div class="grid gap-6 lg:grid-cols-[1.5fr_1fr]">
            <div class="space-y-4">
                <div class="flex flex-wrap items-center gap-2">
                    <span class="inline-flex items-center gap-2 rounded-full bg-white/15 px-3 py-1 text-xs font-semibold">
                        <i class="fas fa-lock"></i> Secure Session
                    </span>
                    <span class="inline-flex items-center gap-2 rounded-full bg-emerald-500/20 px-3 py-1 text-xs font-semibold text-emerald-100">
                        <i class="fas fa-shield-check"></i> Protected Access
                    </span>
                </div>
                <div>
                    <p class="text-sm text-blue-100">Welcome back</p>
                    <h1 class="text-3xl font-bold"><%= customerName %></h1>
                    <p class="mt-2 text-sm text-slate-200">Your primary account is ready for secure transactions.</p>
                </div>
                <div class="grid gap-3 sm:grid-cols-3">
                    <div class="rounded-xl bg-white/10 p-3">
                        <p class="text-xs text-blue-100">Account</p>
                        <p class="mt-1 font-mono text-base font-semibold"><%= hiddenAccountNumber %></p>
                    </div>
                    <div class="rounded-xl bg-white/10 p-3">
                        <p class="text-xs text-blue-100">Last Login</p>
                        <p class="mt-1 text-sm font-semibold"><%= sessionStartText %></p>
                    </div>
                    <div class="rounded-xl bg-white/10 p-3">
                        <p class="text-xs text-blue-100">Device / IP</p>
                        <p class="mt-1 text-sm font-semibold"><%= deviceLabel %></p>
                        <p class="text-xs text-blue-100"><%= remoteAddress %></p>
                    </div>
                </div>
            </div>

            <div class="rounded-2xl border border-white/15 bg-white/10 p-5">
                <p class="text-xs uppercase tracking-[0.18em] text-blue-100">Available Balance</p>
                <p class="mt-2 text-4xl font-bold">₹ <%= balance != null ? String.format("%,.2f", balance) : "0.00" %></p>
                <p class="mt-2 text-sm text-blue-100"><%= healthCopy %></p>
                <div class="mt-4 grid grid-cols-2 gap-3">
                    <div class="rounded-lg bg-white/10 p-3">
                        <p class="text-xs text-blue-100">Net Flow</p>
                        <p class="mt-1 text-base font-semibold <%= netFlow.compareTo(BigDecimal.ZERO) >= 0 ? "text-emerald-200" : "text-rose-200" %>">
                            <%= netFlow.compareTo(BigDecimal.ZERO) >= 0 ? "↑" : "↓" %> ₹ <%= String.format("%,.2f", netFlow.abs()) %>
                        </p>
                    </div>
                    <div class="rounded-lg bg-white/10 p-3">
                        <p class="text-xs text-blue-100">Status</p>
                        <p class="mt-1 text-base font-semibold"><%= healthLabel %></p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Primary Actions -->
    <section class="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
        <div class="flex flex-wrap items-center justify-between gap-2">
            <div>
                <p class="text-sm font-semibold uppercase tracking-[0.18em] text-blue-600">Actions</p>
                <h2 class="text-2xl font-bold text-slate-900">Quick Banking Actions</h2>
            </div>
        </div>

        <div class="mt-4 grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
            <a href="<%= contextPath %>/Transfer.jsp" class="group inline-flex items-center justify-between rounded-xl border border-blue-300 bg-blue-600 px-4 py-3 text-white shadow-sm transition hover:-translate-y-0.5 hover:bg-blue-700">
                <span class="font-semibold">Transfer</span>
                <i class="fas fa-arrow-right text-sm"></i>
            </a>
            <a href="<%= contextPath %>/Withdraw.jsp" class="group inline-flex items-center justify-between rounded-xl border border-rose-300 bg-rose-600 px-4 py-3 text-white shadow-sm transition hover:-translate-y-0.5 hover:bg-rose-700">
                <span class="font-semibold">Withdraw</span>
                <i class="fas fa-arrow-right text-sm"></i>
            </a>
            <a href="<%= contextPath %>/Deposit.jsp" class="group inline-flex items-center justify-between rounded-xl border border-emerald-300 bg-emerald-600 px-4 py-3 text-white shadow-sm transition hover:-translate-y-0.5 hover:bg-emerald-700">
                <span class="font-semibold">Deposit</span>
                <i class="fas fa-arrow-right text-sm"></i>
            </a>
            <a href="<%= contextPath %>/Loan.jsp" class="group inline-flex items-center justify-between rounded-xl border border-slate-300 bg-slate-800 px-4 py-3 text-white shadow-sm transition hover:-translate-y-0.5 hover:bg-slate-900">
                <span class="font-semibold">Loan</span>
                <i class="fas fa-arrow-right text-sm"></i>
            </a>
        </div>
    </section>

    <!-- Details / Analytics -->
    <section class="grid gap-4 lg:grid-cols-3">
        <div class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm lg:col-span-2">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm font-semibold uppercase tracking-[0.16em] text-slate-500">Income vs Spending</p>
                    <h3 class="text-xl font-bold text-slate-900">Trend Overview</h3>
                </div>
                <span class="text-xs text-slate-500">Recent 7 activities</span>
            </div>

            <% if (!trendValues.isEmpty()) { %>
                <div class="mt-5 grid grid-cols-7 gap-2">
                    <%
                        for (int i = 0; i < trendValues.size(); i++) {
                            BigDecimal value = trendValues.get(i);
                            int barHeight = Math.max(14, value.multiply(new BigDecimal("100")).divide(maxTrendAmount, 0, RoundingMode.HALF_UP).intValue());
                            String label = trendLabels.get(i);
                    %>
                        <div class="flex flex-col items-center gap-2">
                            <div class="flex h-28 w-full items-end rounded-lg bg-slate-100 p-1">
                                <div class="w-full rounded-md bg-blue-600" style="height: <%= barHeight %>%;"></div>
                            </div>
                            <span class="text-[11px] text-slate-500"><%= label %></span>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="mt-5 rounded-xl border border-dashed border-slate-300 bg-slate-50 p-6 text-sm text-slate-500">
                    No chart data yet. Make a few transactions to unlock trend insights.
                </div>
            <% } %>

            <div class="mt-5 grid gap-3 md:grid-cols-2">
                <div class="rounded-xl border border-emerald-200 bg-emerald-50 p-4">
                    <p class="text-xs font-semibold uppercase tracking-[0.14em] text-emerald-700">Credits</p>
                    <p class="mt-1 text-xl font-bold text-emerald-800">₹ <%= String.format("%,.2f", totalCredits) %></p>
                    <p class="mt-1 text-sm <%= creditChange >= 0 ? "text-emerald-700" : "text-rose-700" %>">
                        <%= creditChange >= 0 ? "↑" : "↓" %> <%= String.format("%.2f", Math.abs(creditChange)) %>% vs previous window
                    </p>
                </div>
                <div class="rounded-xl border border-rose-200 bg-rose-50 p-4">
                    <p class="text-xs font-semibold uppercase tracking-[0.14em] text-rose-700">Debits</p>
                    <p class="mt-1 text-xl font-bold text-rose-800">₹ <%= String.format("%,.2f", totalDebits) %></p>
                    <p class="mt-1 text-sm <%= debitChange <= 0 ? "text-emerald-700" : "text-rose-700" %>">
                        <%= debitChange <= 0 ? "↓" : "↑" %> <%= String.format("%.2f", Math.abs(debitChange)) %>% vs previous window
                    </p>
                </div>
            </div>
        </div>

        <div class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
            <p class="text-sm font-semibold uppercase tracking-[0.16em] text-slate-500">Details</p>
            <h3 class="text-xl font-bold text-slate-900">Account Snapshot</h3>
            <div class="mt-4 space-y-3">
                <div class="rounded-lg bg-slate-50 p-3">
                    <p class="text-xs text-slate-500">Latest Activity</p>
                    <p class="mt-1 text-sm font-semibold text-slate-900"><%= latestActivityLabel %></p>
                    <p class="text-sm text-slate-600"><%= latestActivitySummary %></p>
                </div>
                <div class="rounded-lg bg-slate-50 p-3">
                    <p class="text-xs text-slate-500">Total Transactions</p>
                    <p class="mt-1 text-lg font-semibold text-slate-900"><%= transactionCount %></p>
                </div>
                <div class="rounded-lg bg-slate-50 p-3">
                    <p class="text-xs text-slate-500">Primary Contact</p>
                    <p class="mt-1 text-sm font-semibold text-slate-900"><%= email != null ? email : "Not available" %></p>
                </div>
            </div>
        </div>
    </section>

    <!-- Transactions -->
    <section class="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
        <div class="flex flex-col gap-4 border-b border-slate-200 pb-4 lg:flex-row lg:items-end lg:justify-between">
            <div>
                <p class="text-sm font-semibold uppercase tracking-[0.16em] text-blue-600">Transactions</p>
                <h2 class="text-2xl font-bold text-slate-900">Recent Account Activity</h2>
                <p class="text-sm text-slate-500">Use search and filters to locate specific entries quickly.</p>
            </div>

            <div class="grid gap-2 sm:grid-cols-2 lg:grid-cols-4 lg:min-w-[760px]">
                <input id="transactionSearch" type="text" placeholder="Search"
                       class="rounded-xl border border-slate-200 px-3 py-2 text-sm outline-none transition focus:border-blue-500 focus:ring-4 focus:ring-blue-100" />
                <select id="transactionTypeFilter" class="rounded-xl border border-slate-200 px-3 py-2 text-sm outline-none transition focus:border-blue-500 focus:ring-4 focus:ring-blue-100">
                    <option value="all">All types</option>
                    <option value="deposit">Deposit</option>
                    <option value="withdrawal">Withdrawal</option>
                    <option value="transfer">Transfer</option>
                    <option value="loan">Loan</option>
                </select>
                <select id="transactionDateFilter" class="rounded-xl border border-slate-200 px-3 py-2 text-sm outline-none transition focus:border-blue-500 focus:ring-4 focus:ring-blue-100">
                    <option value="all">All dates</option>
                    <option value="7">Last 7 days</option>
                    <option value="30">Last 30 days</option>
                    <option value="90">Last 90 days</option>
                </select>
                <input id="transactionAmountFilter" type="number" min="0" step="0.01" placeholder="Min amount"
                       class="rounded-xl border border-slate-200 px-3 py-2 text-sm outline-none transition focus:border-blue-500 focus:ring-4 focus:ring-blue-100" />
            </div>
        </div>

        <% if (!recentTransactions.isEmpty()) { %>
            <div class="mt-4 overflow-x-auto">
                <table class="min-w-full border-separate border-spacing-y-2">
                    <thead>
                        <tr>
                            <th class="px-3 py-2 text-left text-xs font-semibold uppercase tracking-[0.14em] text-slate-500">Date & Time</th>
                            <th class="px-3 py-2 text-left text-xs font-semibold uppercase tracking-[0.14em] text-slate-500">Details</th>
                            <th class="px-3 py-2 text-left text-xs font-semibold uppercase tracking-[0.14em] text-slate-500">Type</th>
                            <th class="px-3 py-2 text-left text-xs font-semibold uppercase tracking-[0.14em] text-slate-500">Amount</th>
                            <th class="px-3 py-2 text-left text-xs font-semibold uppercase tracking-[0.14em] text-slate-500">Status</th>
                        </tr>
                    </thead>
                    <tbody id="transactionTableBody">
                        <%
                            int rowLimit = Math.min(10, recentTransactions.size());
                            for (int i = 0; i < rowLimit; i++) {
                                Transaction t = recentTransactions.get(i);
                                if (t == null) {
                                    continue;
                                }

                                String txType = t.txType() != null ? t.txType().toUpperCase() : "ACTIVITY";
                                BigDecimal amount = t.amount() != null ? t.amount() : BigDecimal.ZERO;
                                boolean sentByThisAccount = t.senderAccount() != null && t.senderAccount().equals(accountNumber);
                                boolean isCredit = "DEPOSIT".equals(txType) || "LOAN".equals(txType) || ("TRANSFER".equals(txType) && !sentByThisAccount);

                                String detailsText;
                                if ("TRANSFER".equals(txType)) {
                                    detailsText = sentByThisAccount
                                            ? "To A/C " + maskAccount.apply(t.receiverAccount())
                                            : "From A/C " + maskAccount.apply(t.senderAccount());
                                } else if ("DEPOSIT".equals(txType)) {
                                    detailsText = "Cash deposit";
                                } else if ("WITHDRAWAL".equals(txType)) {
                                    detailsText = "Cash withdrawal";
                                } else if ("LOAN".equals(txType)) {
                                    detailsText = "Loan disbursement";
                                } else {
                                    detailsText = "Account activity";
                                }

                                String typeClass = "DEPOSIT".equals(txType)
                                        ? "bg-emerald-50 text-emerald-700"
                                        : "WITHDRAWAL".equals(txType)
                                        ? "bg-rose-50 text-rose-700"
                                        : "LOAN".equals(txType)
                                        ? "bg-blue-50 text-blue-700"
                                        : "bg-slate-100 text-slate-700";

                                long txEpoch = t.createdAt() != null
                                        ? t.createdAt().atZone(ZoneId.systemDefault()).toEpochSecond()
                                        : 0L;
                                String rowSearch = (txType + " " + detailsText + " " + amount + " " + (t.createdAt() != null ? formatter.format(t.createdAt()) : "")).toLowerCase();
                        %>
                            <tr class="transaction-row rounded-xl bg-slate-50 transition hover:bg-slate-100"
                                data-type="<%= txType.toLowerCase() %>"
                                data-search="<%= rowSearch %>"
                                data-epoch="<%= txEpoch %>"
                                data-amount="<%= amount %>">
                                <td class="rounded-l-xl px-3 py-3 text-sm text-slate-600"><%= t.createdAt() != null ? formatter.format(t.createdAt()) : "-" %></td>
                                <td class="px-3 py-3">
                                    <p class="text-sm font-semibold text-slate-900"><%= detailsText %></p>
                                    <p class="text-xs text-slate-500"><%= sentByThisAccount ? "Outgoing" : "Incoming" %></p>
                                </td>
                                <td class="px-3 py-3">
                                    <span class="inline-flex rounded-full px-2.5 py-1 text-xs font-semibold <%= typeClass %>"><%= txType %></span>
                                </td>
                                <td class="px-3 py-3 text-sm font-semibold <%= isCredit ? "text-emerald-700" : "text-rose-700" %>">
                                    <%= isCredit ? "+" : "-" %> ₹ <%= String.format("%,.2f", amount) %>
                                </td>
                                <td class="rounded-r-xl px-3 py-3">
                                    <span class="inline-flex rounded-full bg-emerald-100 px-2.5 py-1 text-xs font-semibold text-emerald-700">Completed</span>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <div id="noFilterResults" class="mt-4 hidden rounded-xl border border-dashed border-slate-300 bg-slate-50 px-4 py-6 text-center">
                <p class="text-sm font-semibold text-slate-900">No matching transactions</p>
                <p class="mt-1 text-sm text-slate-500">Try adjusting search, date, type, or amount filters.</p>
                <button id="resetFiltersBtn" class="mt-3 rounded-lg bg-slate-900 px-3 py-2 text-xs font-semibold text-white transition hover:bg-slate-800">Reset filters</button>
            </div>
        <% } else { %>
            <div class="mt-4 rounded-xl border border-dashed border-slate-300 bg-slate-50 px-4 py-10 text-center">
                <i class="fas fa-receipt text-3xl text-slate-400"></i>
                <p class="mt-3 text-lg font-semibold text-slate-900">No transactions yet</p>
                <p class="mt-1 text-sm text-slate-500">Once you deposit or transfer money, details will appear here.</p>
            </div>
        <% } %>
    </section>
</div>

<script>
    (function () {
        const skeleton = document.getElementById('dashboardSkeleton');
        const content = document.getElementById('dashboardContent');
        const searchInput = document.getElementById('transactionSearch');
        const typeFilter = document.getElementById('transactionTypeFilter');
        const dateFilter = document.getElementById('transactionDateFilter');
        const amountFilter = document.getElementById('transactionAmountFilter');
        const resetBtn = document.getElementById('resetFiltersBtn');
        const rows = Array.from(document.querySelectorAll('.transaction-row'));
        const noResults = document.getElementById('noFilterResults');

        window.requestAnimationFrame(() => {
            setTimeout(() => {
                if (skeleton) skeleton.classList.add('hidden');
                if (content) content.classList.remove('hidden');
            }, 250);
        });

        function dateMatches(epochValue, daysRange) {
            if (daysRange === 'all') return true;
            const epoch = Number(epochValue || 0);
            if (!epoch) return false;
            const now = Math.floor(Date.now() / 1000);
            const limit = Number(daysRange) * 24 * 60 * 60;
            return (now - epoch) <= limit;
        }

        function applyFilters() {
            if (!rows.length) return;

            const search = (searchInput ? searchInput.value : '').trim().toLowerCase();
            const type = typeFilter ? typeFilter.value : 'all';
            const days = dateFilter ? dateFilter.value : 'all';
            const minAmount = amountFilter && amountFilter.value ? Number(amountFilter.value) : 0;
            let visibleCount = 0;

            rows.forEach(row => {
                const rowType = row.dataset.type || '';
                const rowSearch = row.dataset.search || '';
                const rowEpoch = row.dataset.epoch || '0';
                const rowAmount = Number(row.dataset.amount || 0);

                const matchesSearch = !search || rowSearch.includes(search);
                const matchesType = type === 'all' || rowType === type;
                const matchesDate = dateMatches(rowEpoch, days);
                const matchesAmount = rowAmount >= minAmount;

                const visible = matchesSearch && matchesType && matchesDate && matchesAmount;
                row.classList.toggle('hidden', !visible);
                if (visible) visibleCount += 1;
            });

            if (noResults) {
                noResults.classList.toggle('hidden', visibleCount > 0);
            }
        }

        if (searchInput) searchInput.addEventListener('input', applyFilters);
        if (typeFilter) typeFilter.addEventListener('change', applyFilters);
        if (dateFilter) dateFilter.addEventListener('change', applyFilters);
        if (amountFilter) amountFilter.addEventListener('input', applyFilters);

        if (resetBtn) {
            resetBtn.addEventListener('click', function () {
                if (searchInput) searchInput.value = '';
                if (typeFilter) typeFilter.value = 'all';
                if (dateFilter) dateFilter.value = 'all';
                if (amountFilter) amountFilter.value = '';
                applyFilters();
            });
        }

        applyFilters();
    })();
</script>

<jsp:include page="/includes/footer.jsp" />
