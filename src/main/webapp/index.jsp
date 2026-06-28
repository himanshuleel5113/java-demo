<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="includes/header.jsp" />

<!-- Hero Section with Animated Gradient Background -->
<div class="relative overflow-hidden min-h-[90vh] flex items-center">
    <!-- Animated background layers -->
    <div class="absolute inset-0 z-0">
        <div class="absolute inset-0 bg-gradient-to-br from-blue-50 to-indigo-50 dark:from-slate-900 dark:to-indigo-950 transition-colors duration-500"></div>
        <div class="absolute top-0 right-0 -mr-40 -mt-40 w-96 h-96 rounded-full bg-blue-400/20 blur-3xl animate-pulse-slow"></div>
        <div class="absolute bottom-0 left-0 -ml-40 -mb-40 w-[500px] h-[500px] rounded-full bg-indigo-500/10 blur-3xl animate-float"></div>
        <!-- Abstract shape -->
        <div class="absolute top-1/4 right-1/4 w-64 h-64 bg-secondary/10 rounded-full blur-3xl animate-pulse-slow" style="animation-delay: 1s;"></div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10 py-20 w-full">
        <div class="grid lg:grid-cols-2 gap-12 lg:gap-8 items-center">
            
            <!-- Hero Text Content -->
            <div class="text-center lg:text-left">
                <div class="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-300 font-medium text-sm mb-6 animate-float">
                    <span class="relative flex h-3 w-3">
                      <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-blue-400 opacity-75"></span>
                      <span class="relative inline-flex rounded-full h-3 w-3 bg-blue-500"></span>
                    </span>
                    Smart Banking for the Digital Era
                </div>
                
                <h1 class="text-5xl lg:text-7xl font-brand font-bold text-gray-900 dark:text-white leading-tight mb-6">
                    Bank <span class="text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-indigo-600 dark:from-blue-400 dark:to-indigo-400">Smarter</span>,<br>
                    Live Better.
                </h1>
                
                <p class="text-lg lg:text-xl text-gray-600 dark:text-gray-400 mb-8 max-w-2xl mx-auto lg:mx-0">
                    Experience seamless financial control with our next-generation digital banking platform. Fast, secure, and designed around you.
                </p>
                
                <div class="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start">
                    <a href="SignUp.jsp" class="btn-primary flex items-center justify-center gap-2 group text-lg px-8 py-4">
                        Open Account <i class="fas fa-arrow-right group-hover:translate-x-1 transition-transform"></i>
                    </a>
                    <a href="Login.jsp" class="btn-secondary flex items-center justify-center gap-2 text-lg px-8 py-4">
                        Sign In <i class="fas fa-lock text-slate-400"></i>
                    </a>
                </div>
                
                <div class="mt-10 flex items-center justify-center lg:justify-start gap-6 text-sm text-gray-500 dark:text-gray-400">
                    <div class="flex items-center gap-2">
                        <i class="fas fa-check-circle text-green-500"></i> No hidden fees
                    </div>
                    <div class="flex items-center gap-2">
                        <i class="fas fa-check-circle text-green-500"></i> RBI Regulated
                    </div>
                    <div class="flex items-center gap-2">
                        <i class="fas fa-check-circle text-green-500"></i> 24/7 Support
                    </div>
                </div>
            </div>

            <!-- Hero Image/Cards -->
            <div class="relative hidden md:block">
                <!-- Main Glass Card -->
                <div class="glass-panel p-6 rounded-3xl relative z-20 animate-float" style="animation-duration: 8s;">
                    <div class="flex justify-between items-center mb-8">
                        <div>
                            <p class="text-sm text-gray-500 dark:text-gray-400">Total Balance</p>
                            <h3 class="text-3xl font-bold font-brand text-gray-900 dark:text-white">₹ 2,45,678.00</h3>
                        </div>
                        <div class="w-12 h-12 rounded-full bg-blue-100 dark:bg-blue-900/50 flex items-center justify-center text-blue-600 dark:text-blue-400">
                            <i class="fas fa-wallet text-xl"></i>
                        </div>
                    </div>
                    
                    <div class="space-y-4">
                        <div class="p-4 rounded-2xl bg-white/50 dark:bg-slate-800/50 flex items-center justify-between">
                            <div class="flex items-center gap-4">
                                <div class="w-10 h-10 rounded-full bg-green-100 dark:bg-green-900/30 flex items-center justify-center text-green-600">
                                    <i class="fas fa-arrow-down"></i>
                                </div>
                                <div>
                                    <p class="font-medium text-gray-900 dark:text-white">Salary Credited</p>
                                    <p class="text-xs text-gray-500 dark:text-gray-400">Today, 09:00 AM</p>
                                </div>
                            </div>
                            <span class="font-semibold text-green-600">+₹ 85,000</span>
                        </div>
                        
                        <div class="p-4 rounded-2xl bg-white/50 dark:bg-slate-800/50 flex items-center justify-between">
                            <div class="flex items-center gap-4">
                                <div class="w-10 h-10 rounded-full bg-red-100 dark:bg-red-900/30 flex items-center justify-center text-red-600">
                                    <i class="fas fa-shopping-bag"></i>
                                </div>
                                <div>
                                    <p class="font-medium text-gray-900 dark:text-white">Amazon Purchase</p>
                                    <p class="text-xs text-gray-500 dark:text-gray-400">Yesterday</p>
                                </div>
                            </div>
                            <span class="font-semibold text-gray-900 dark:text-white">-₹ 4,299</span>
                        </div>
                    </div>
                </div>

                <!-- Floating elements behind -->
                <div class="absolute -right-8 -bottom-8 glass-panel p-4 rounded-2xl z-30 animate-float shadow-xl" style="animation-delay: 1.5s;">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 rounded-full bg-secondary text-white flex items-center justify-center">
                            <i class="fas fa-bolt"></i>
                        </div>
                        <div>
                            <p class="text-xs text-gray-500 dark:text-gray-400">Instant Transfer</p>
                            <p class="font-bold text-gray-900 dark:text-white">Successful</p>
                        </div>
                    </div>
                </div>

                <div class="absolute -left-12 top-12 glass-panel p-4 rounded-2xl z-10 animate-float shadow-xl" style="animation-delay: 3s;">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 rounded-full bg-purple-500 text-white flex items-center justify-center">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <div>
                            <p class="text-xs text-gray-500 dark:text-gray-400">Security</p>
                            <p class="font-bold text-gray-900 dark:text-white">Protected</p>
                        </div>
                    </div>
                </div>
            </div>
            
        </div>
    </div>
</div>

<!-- Features Section -->
<section class="py-24 bg-white dark:bg-slate-900 transition-colors duration-300">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center max-w-3xl mx-auto mb-16">
            <h2 class="text-blue-600 font-semibold tracking-wide uppercase text-sm mb-2">Features</h2>
            <h3 class="text-3xl md:text-4xl font-brand font-bold text-gray-900 dark:text-white mb-4">Everything you need, nothing you don't</h3>
            <p class="text-gray-600 dark:text-gray-400 text-lg">We've stripped away the complexity to bring you a banking experience that is fast, intuitive, and secure.</p>
        </div>

        <div class="grid md:grid-cols-3 gap-8">
            <!-- Feature 1 -->
            <div class="p-8 rounded-3xl bg-slate-50 dark:bg-slate-800/50 border border-slate-100 dark:border-slate-800 hover:-translate-y-2 transition-all duration-300 group">
                <div class="w-14 h-14 rounded-2xl bg-blue-100 dark:bg-blue-900/40 text-blue-600 flex items-center justify-center text-2xl mb-6 group-hover:scale-110 transition-transform">
                    <i class="fas fa-mobile-alt"></i>
                </div>
                <h4 class="text-xl font-bold text-gray-900 dark:text-white mb-3">100% Digital</h4>
                <p class="text-gray-600 dark:text-gray-400 leading-relaxed">Open your account in minutes right from your phone. No branch visits, no paperwork, no hassle.</p>
            </div>

            <!-- Feature 2 -->
            <div class="p-8 rounded-3xl bg-slate-50 dark:bg-slate-800/50 border border-slate-100 dark:border-slate-800 hover:-translate-y-2 transition-all duration-300 group">
                <div class="w-14 h-14 rounded-2xl bg-green-100 dark:bg-green-900/40 text-green-600 flex items-center justify-center text-2xl mb-6 group-hover:scale-110 transition-transform">
                    <i class="fas fa-chart-line"></i>
                </div>
                <h4 class="text-xl font-bold text-gray-900 dark:text-white mb-3">High Yield Savings</h4>
                <p class="text-gray-600 dark:text-gray-400 leading-relaxed">Watch your money grow faster with our industry-leading interest rates on all savings accounts.</p>
            </div>

            <!-- Feature 3 -->
            <div class="p-8 rounded-3xl bg-slate-50 dark:bg-slate-800/50 border border-slate-100 dark:border-slate-800 hover:-translate-y-2 transition-all duration-300 group">
                <div class="w-14 h-14 rounded-2xl bg-purple-100 dark:bg-purple-900/40 text-purple-600 flex items-center justify-center text-2xl mb-6 group-hover:scale-110 transition-transform">
                    <i class="fas fa-lock"></i>
                </div>
                <h4 class="text-xl font-bold text-gray-900 dark:text-white mb-3">Bank-Grade Security</h4>
                <p class="text-gray-600 dark:text-gray-400 leading-relaxed">Your data and money are protected by 256-bit encryption, biometric auth, and AI fraud detection.</p>
            </div>
        </div>
    </div>
</section>

<!-- Stats / Trust Section -->
<section class="py-20 border-y border-slate-100 dark:border-slate-800 bg-slate-50 dark:bg-slate-900/50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-2 md:grid-cols-4 gap-8 text-center">
            <div>
                <p class="text-4xl font-brand font-bold text-primary dark:text-white mb-2">2M+</p>
                <p class="text-sm font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Active Users</p>
            </div>
            <div>
                <p class="text-4xl font-brand font-bold text-primary dark:text-white mb-2">₹500B</p>
                <p class="text-sm font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Processed</p>
            </div>
            <div>
                <p class="text-4xl font-brand font-bold text-primary dark:text-white mb-2">4.9/5</p>
                <p class="text-sm font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">App Rating</p>
            </div>
            <div>
                <p class="text-4xl font-brand font-bold text-primary dark:text-white mb-2">24/7</p>
                <p class="text-sm font-medium text-slate-500 dark:text-slate-400 uppercase tracking-wider">Support</p>
            </div>
        </div>
    </div>
</section>

<!-- CTA Section -->
<section class="py-24 relative overflow-hidden">
    <div class="absolute inset-0 bg-primary"></div>
    <!-- Decorative background elements -->
    <div class="absolute top-0 right-0 w-64 h-64 bg-blue-500 rounded-full blur-3xl opacity-20 transform translate-x-1/2 -translate-y-1/2"></div>
    <div class="absolute bottom-0 left-0 w-64 h-64 bg-secondary rounded-full blur-3xl opacity-20 transform -translate-x-1/2 translate-y-1/2"></div>
    
    <div class="relative z-10 max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <h2 class="text-4xl md:text-5xl font-brand font-bold text-white mb-6">Ready to upgrade your banking?</h2>
        <p class="text-xl text-blue-100 mb-10">Join millions of customers who have already made the switch to AceBank. It takes just 3 minutes to open an account.</p>
        <a href="SignUp.jsp" class="inline-flex items-center justify-center px-8 py-4 text-lg font-bold rounded-xl text-primary bg-white hover:bg-gray-50 transition-colors shadow-xl hover:shadow-2xl hover:-translate-y-1 duration-300">
            Get Started Today
        </a>
    </div>
</section>

<jsp:include page="includes/footer.jsp" />