<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.acebank.lite.models.CardRequest" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    if(accountNumber == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
    List<CardRequest> cardsList = (List<CardRequest>) request.getAttribute("cardsList");
%>
<jsp:include page="/includes/header.jsp" />

<div class="max-w-6xl mx-auto px-4 py-8 page-enter">
    <div class="mb-8 flex flex-col md:flex-row md:items-end justify-between gap-4">
        <div>
            <h1 class="text-3xl font-brand font-bold text-slate-900 dark:text-white">Card Services</h1>
            <p class="text-slate-500 dark:text-slate-400 mt-1">Manage your debit and credit cards</p>
        </div>
        <form action="<%= request.getContextPath() %>/Cards" method="POST" class="inline">
            <input type="hidden" name="action" value="request">
            <input type="hidden" name="cardType" value="DEBIT_VISA">
            <button type="submit" class="btn-primary py-2.5 px-5 flex items-center gap-2" onclick="return confirm('Are you sure you want to request a new Debit Card?');">
                <i class="fas fa-plus"></i> Request New Card
            </button>
        </form>
    </div>

    <% if(session.getAttribute("successMessage") != null) { %>
        <div class="mb-6 p-4 rounded-xl bg-emerald-50 dark:bg-emerald-900/20 border border-emerald-200 dark:border-emerald-800/30 flex items-start gap-3">
            <i class="fas fa-check-circle text-emerald-500 mt-0.5"></i>
            <p class="text-sm font-medium text-emerald-700 dark:text-emerald-400"><%= session.getAttribute("successMessage") %></p>
        </div>
        <% session.removeAttribute("successMessage"); %>
    <% } %>

    <% if(session.getAttribute("errorMessage") != null) { %>
        <div class="mb-6 p-4 rounded-xl bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800/30 flex items-start gap-3">
            <i class="fas fa-exclamation-circle text-red-500 mt-0.5"></i>
            <p class="text-sm font-medium text-red-700 dark:text-red-400"><%= session.getAttribute("errorMessage") %></p>
        </div>
        <% session.removeAttribute("errorMessage"); %>
    <% } %>

    <!-- Active Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-12">
        
        <% if (cardsList != null && !cardsList.isEmpty()) { 
            for (CardRequest c : cardsList) { 
                boolean isBlocked = c.isBlocked();
                boolean isCredit = c.cardType().contains("CREDIT");
        %>
        <!-- Card Item -->
        <div class="relative group perspective">
            <div class="w-full h-56 rounded-2xl p-6 flex flex-col justify-between text-white relative overflow-hidden shadow-2xl transition-transform duration-500 preserve-3d group-hover:rotate-y-12 <%= isBlocked ? "bg-slate-700 opacity-60 grayscale" : (isCredit ? "bg-gradient-to-br from-indigo-800 to-purple-900" : "bg-gradient-to-br from-slate-800 to-slate-900") %> border border-slate-700">
                <!-- Card Background Pattern -->
                <div class="absolute inset-0 opacity-20">
                    <svg width="100%" height="100%" xmlns="http://www.w3.org/2000/svg">
                        <defs><pattern id="hexagons" width="50" height="43.4" patternUnits="userSpaceOnUse" patternTransform="scale(2) translate(2)"><polygon points="24.8,22 37.3,29.2 37.3,43.7 24.8,50.9 12.3,43.7 12.3,29.2" fill="none" stroke="#ffffff" stroke-width="1"/></pattern></defs>
                        <rect width="100%" height="100%" fill="url(#hexagons)"/>
                    </svg>
                </div>
                
                <div class="relative z-10 flex justify-between items-start">
                    <span class="text-2xl font-bold italic tracking-wider">Ace<span class="text-yellow-400">Bank</span></span>
                    <i class="fab fa-cc-visa text-4xl opacity-80"></i>
                </div>
                
                <div class="relative z-10">
                    <i class="fas fa-microchip text-3xl text-yellow-200/80 mb-2"></i>
                    <p class="font-mono text-xl tracking-widest mb-1 shadow-sm"><%= c.cardNumberMasked() %></p>
                    <div class="flex justify-between items-end mt-4">
                        <div>
                            <p class="text-[10px] uppercase tracking-wider text-slate-400 font-semibold mb-0.5">Card Holder</p>
                            <p class="font-bold text-sm tracking-widest uppercase"><%= session.getAttribute("firstName") %></p>
                        </div>
                        <div class="text-right flex items-center gap-2">
                            <% if (isBlocked) { %>
                            <span class="bg-red-500 text-white text-[10px] px-2 py-0.5 rounded uppercase font-bold">BLOCKED</span>
                            <% } else if ("PENDING".equals(c.status())) { %>
                            <span class="bg-amber-500 text-white text-[10px] px-2 py-0.5 rounded uppercase font-bold">PENDING</span>
                            <% } %>
                            <div>
                                <p class="text-[10px] uppercase tracking-wider text-slate-400 font-semibold mb-0.5">Valid Thru</p>
                                <p class="font-bold text-sm font-mono">12/28</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Quick Actions -->
            <div class="flex justify-center gap-4 mt-4">
                <button class="px-4 py-2 bg-slate-100 dark:bg-slate-800 rounded-lg text-sm font-semibold text-slate-600 dark:text-slate-300 hover:text-blue-600 transition-colors">
                    <i class="fas fa-eye mr-1"></i> Details
                </button>
                <form action="<%= request.getContextPath() %>/Cards" method="POST" class="inline">
                    <input type="hidden" name="action" value="toggleBlock">
                    <input type="hidden" name="cardId" value="<%= c.id() %>">
                    <input type="hidden" name="blockStatus" value="<%= !isBlocked %>">
                    <button type="submit" class="px-4 py-2 bg-slate-100 dark:bg-slate-800 rounded-lg text-sm font-semibold <%= isBlocked ? "text-emerald-500 hover:text-emerald-600" : "text-red-500 hover:text-red-600" %> transition-colors">
                        <i class="fas <%= isBlocked ? "fa-unlock" : "fa-ban" %> mr-1"></i> <%= isBlocked ? "Unblock" : "Block" %>
                    </button>
                </form>
            </div>
        </div>
        <% 
            }
        } else { 
        %>
            <div class="col-span-1 md:col-span-2 lg:col-span-3 glass-panel p-8 text-center rounded-3xl border border-dashed border-slate-300 dark:border-slate-700">
                <i class="fas fa-credit-card text-4xl text-slate-400 mb-4"></i>
                <p class="text-slate-500">You don't have any active cards.</p>
            </div>
        <% } %>

    </div>

    <!-- Controls & Settings -->
    <div class="glass-panel rounded-3xl p-8 shadow-xl">
        <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-6">Global Card Controls</h3>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div class="flex items-center justify-between p-4 rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/50">
                <div>
                    <p class="font-semibold text-slate-900 dark:text-white">Online Transactions</p>
                    <p class="text-sm text-slate-500">Enable for e-commerce purchases</p>
                </div>
                <label class="relative inline-flex items-center cursor-pointer">
                    <input type="checkbox" value="" class="sr-only peer" checked>
                    <div class="w-11 h-6 bg-slate-300 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-emerald-500"></div>
                </label>
            </div>

            <div class="flex items-center justify-between p-4 rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/50">
                <div>
                    <p class="font-semibold text-slate-900 dark:text-white">International Usage</p>
                    <p class="text-sm text-slate-500">Enable for global transactions</p>
                </div>
                <label class="relative inline-flex items-center cursor-pointer">
                    <input type="checkbox" value="" class="sr-only peer">
                    <div class="w-11 h-6 bg-slate-300 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-emerald-500"></div>
                </label>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
