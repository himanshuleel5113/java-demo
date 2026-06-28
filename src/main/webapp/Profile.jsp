<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Integer accountNumber = (Integer) session.getAttribute("accountNumber");
    String firstName = (String) session.getAttribute("firstName");
    String lastName = (String) session.getAttribute("lastName");
    String email = (String) session.getAttribute("email");
    String aadhaar = (String) session.getAttribute("aadhaarNo");

    if(accountNumber == null) {
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
        return;
    }
%>
<jsp:include page="/includes/header.jsp" />

<div class="max-w-4xl mx-auto px-4 py-8 page-enter">
    <div class="mb-8">
        <h1 class="text-3xl font-brand font-bold text-slate-900 dark:text-white">My Profile</h1>
        <p class="text-slate-500 dark:text-slate-400 mt-1">Manage your account details and settings</p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
        <!-- Profile Sidebar -->
        <div class="glass-panel rounded-3xl p-6 shadow-xl h-max text-center">
            <div class="relative inline-block mb-4">
                <div class="w-24 h-24 rounded-full bg-gradient-to-br from-blue-500 to-indigo-600 text-white flex items-center justify-center text-4xl font-brand font-bold shadow-lg mx-auto">
                    <%= firstName != null ? firstName.substring(0,1).toUpperCase() : "U" %>
                </div>
                <button class="absolute bottom-0 right-0 w-8 h-8 bg-white dark:bg-slate-800 rounded-full border border-slate-200 dark:border-slate-700 flex items-center justify-center text-blue-600 dark:text-blue-400 shadow-sm hover:bg-slate-50 dark:hover:bg-slate-700 transition-colors">
                    <i class="fas fa-camera text-xs"></i>
                </button>
            </div>
            
            <h2 class="text-xl font-bold text-slate-900 dark:text-white"><%= firstName %> <%= lastName != null ? lastName : "" %></h2>
            <p class="text-sm text-slate-500 dark:text-slate-400 mb-6"><%= email %></p>

            <div class="flex flex-col gap-2">
                <a href="#personal-info" class="p-3 rounded-xl bg-blue-50 dark:bg-blue-900/20 text-blue-700 dark:text-blue-400 font-semibold text-sm flex items-center gap-3 transition-colors">
                    <i class="fas fa-user-circle w-5"></i> Personal Info
                </a>
                <a href="<%= request.getContextPath() %>/ChangePassword.jsp" class="p-3 rounded-xl hover:bg-slate-50 dark:hover:bg-slate-800/50 text-slate-600 dark:text-slate-300 font-medium text-sm flex items-center gap-3 transition-colors">
                    <i class="fas fa-lock w-5"></i> Security
                </a>
                <a href="#kyc" class="p-3 rounded-xl hover:bg-slate-50 dark:hover:bg-slate-800/50 text-slate-600 dark:text-slate-300 font-medium text-sm flex items-center gap-3 transition-colors">
                    <i class="fas fa-id-card w-5"></i> KYC Documents
                </a>
                <a href="#preferences" class="p-3 rounded-xl hover:bg-slate-50 dark:hover:bg-slate-800/50 text-slate-600 dark:text-slate-300 font-medium text-sm flex items-center gap-3 transition-colors">
                    <i class="fas fa-cog w-5"></i> Preferences
                </a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="md:col-span-2 space-y-6">
            <!-- Personal Info Form -->
            <div id="personal-info" class="glass-panel rounded-3xl p-8 shadow-xl">
                <div class="flex items-center justify-between mb-6 border-b border-slate-200 dark:border-slate-700/50 pb-4">
                    <h3 class="text-xl font-bold text-slate-900 dark:text-white">Personal Information</h3>
                    <button class="text-sm font-semibold text-blue-600 dark:text-blue-400 hover:underline">Edit</button>
                </div>

                <form class="space-y-6">
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">First Name</label>
                            <input type="text" value="<%= firstName %>" class="input-field bg-slate-50 dark:bg-slate-800/50" readonly>
                        </div>
                        <div>
                            <label class="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Last Name</label>
                            <input type="text" value="<%= lastName != null ? lastName : "" %>" class="input-field bg-slate-50 dark:bg-slate-800/50" readonly>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Email Address</label>
                            <input type="email" value="<%= email %>" class="input-field bg-slate-50 dark:bg-slate-800/50" readonly>
                        </div>
                        <div>
                            <label class="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Phone Number</label>
                            <input type="tel" value="+91 XXXXX XXXXX" class="input-field bg-slate-50 dark:bg-slate-800/50" readonly>
                        </div>
                    </div>

                    <div>
                        <label class="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Residential Address</label>
                        <textarea rows="2" class="input-field bg-slate-50 dark:bg-slate-800/50" readonly>123 Banking Street, Financial District, Mumbai, India</textarea>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Date of Birth</label>
                            <input type="text" value="01 Jan 1990" class="input-field bg-slate-50 dark:bg-slate-800/50" readonly>
                        </div>
                        <div>
                            <label class="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-2">Aadhaar / SSN</label>
                            <div class="relative">
                                <input type="password" value="<%= aadhaar != null ? aadhaar : "XXXXXXXXXXXX" %>" class="input-field bg-slate-50 dark:bg-slate-800/50 pr-10" readonly>
                                <button type="button" class="absolute inset-y-0 right-0 pr-3 flex items-center text-slate-400 hover:text-slate-600">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>

            <!-- KYC Status -->
            <div id="kyc" class="glass-panel rounded-3xl p-8 shadow-xl">
                <div class="flex items-center justify-between mb-6 border-b border-slate-200 dark:border-slate-700/50 pb-4">
                    <h3 class="text-xl font-bold text-slate-900 dark:text-white">KYC Status</h3>
                    <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-100 dark:bg-emerald-900/30 text-emerald-700 dark:text-emerald-400 text-xs font-bold uppercase tracking-wider">
                        <i class="fas fa-check-circle"></i> Verified
                    </span>
                </div>
                <div class="space-y-4">
                    <div class="flex items-center justify-between p-4 rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/50">
                        <div class="flex items-center gap-4">
                            <div class="w-10 h-10 rounded-full bg-blue-100 dark:bg-blue-900/40 text-blue-600 dark:text-blue-400 flex items-center justify-center">
                                <i class="fas fa-id-card"></i>
                            </div>
                            <div>
                                <p class="font-semibold text-slate-900 dark:text-white">Identity Proof</p>
                                <p class="text-xs text-slate-500">Aadhaar Card • Verified on 15 Jan 2024</p>
                            </div>
                        </div>
                        <button class="text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300">
                            <i class="fas fa-download"></i>
                        </button>
                    </div>
                    <div class="flex items-center justify-between p-4 rounded-xl border border-slate-200 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/50">
                        <div class="flex items-center gap-4">
                            <div class="w-10 h-10 rounded-full bg-blue-100 dark:bg-blue-900/40 text-blue-600 dark:text-blue-400 flex items-center justify-center">
                                <i class="fas fa-map-marker-alt"></i>
                            </div>
                            <div>
                                <p class="font-semibold text-slate-900 dark:text-white">Address Proof</p>
                                <p class="text-xs text-slate-500">Utility Bill • Verified on 15 Jan 2024</p>
                            </div>
                        </div>
                        <button class="text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-300">
                            <i class="fas fa-download"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
