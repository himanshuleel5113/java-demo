    </main> <!-- Close main-content -->

    <!-- Footer -->
    <footer class="bg-white dark:bg-slate-900 border-t border-slate-200 dark:border-slate-800 mt-auto">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="grid grid-cols-2 md:grid-cols-4 gap-8 py-12">
                <div>
                    <a href="#" class="flex items-center gap-2 mb-6">
                        <div class="h-8 w-8 rounded-lg bg-gradient-to-br from-primary to-blue-800 flex items-center justify-center text-white shadow">
                            <i class="fas fa-university text-sm"></i>
                        </div>
                        <div class="font-brand text-xl font-bold tracking-tight text-primary dark:text-white">
                            Ace<span class="text-secondary">Bank</span>
                        </div>
                    </a>
                    <p class="text-sm text-slate-500 dark:text-slate-400 leading-relaxed mb-6">
                        Experience the future of banking with AceBank. Secure, fast, and reliable financial solutions tailored for you.
                    </p>
                    <div class="flex space-x-3">
                        <a href="#" class="h-9 w-9 rounded-full bg-slate-100 dark:bg-slate-800 flex items-center justify-center text-slate-500 hover:bg-blue-600 hover:text-white dark:hover:bg-blue-600 dark:hover:text-white transition-colors duration-300">
                            <i class="fab fa-facebook-f text-sm"></i>
                        </a>
                        <a href="#" class="h-9 w-9 rounded-full bg-slate-100 dark:bg-slate-800 flex items-center justify-center text-slate-500 hover:bg-sky-500 hover:text-white dark:hover:bg-sky-500 dark:hover:text-white transition-colors duration-300">
                            <i class="fab fa-twitter text-sm"></i>
                        </a>
                        <a href="#" class="h-9 w-9 rounded-full bg-slate-100 dark:bg-slate-800 flex items-center justify-center text-slate-500 hover:bg-pink-600 hover:text-white dark:hover:bg-pink-600 dark:hover:text-white transition-colors duration-300">
                            <i class="fab fa-instagram text-sm"></i>
                        </a>
                    </div>
                </div>

                <div>
                    <h4 class="font-semibold text-slate-800 dark:text-white mb-6">Products</h4>
                    <ul class="space-y-3 text-sm text-slate-600 dark:text-slate-400">
                        <li><a href="#" class="hover:text-blue-600 dark:hover:text-blue-400 transition-colors">Savings Account</a></li>
                        <li><a href="#" class="hover:text-blue-600 dark:hover:text-blue-400 transition-colors">Current Account</a></li>
                        <li><a href="#" class="hover:text-blue-600 dark:hover:text-blue-400 transition-colors">Fixed Deposits</a></li>
                        <li><a href="#" class="hover:text-blue-600 dark:hover:text-blue-400 transition-colors">Credit Cards</a></li>
                        <li><a href="#" class="hover:text-blue-600 dark:hover:text-blue-400 transition-colors">Personal Loans</a></li>
                    </ul>
                </div>

                <div>
                    <h4 class="font-semibold text-slate-800 dark:text-white mb-6">Support</h4>
                    <ul class="space-y-3 text-sm text-slate-600 dark:text-slate-400">
                        <li><a href="#" class="hover:text-blue-600 dark:hover:text-blue-400 transition-colors">Help Center</a></li>
                        <li><a href="#" class="hover:text-blue-600 dark:hover:text-blue-400 transition-colors">Contact Us</a></li>
                        <li><a href="#" class="hover:text-blue-600 dark:hover:text-blue-400 transition-colors">Branch Locator</a></li>
                        <li><a href="#" class="hover:text-blue-600 dark:hover:text-blue-400 transition-colors">Report Fraud</a></li>
                    </ul>
                </div>

                <div>
                    <h4 class="font-semibold text-slate-800 dark:text-white mb-6">Contact Info</h4>
                    <ul class="space-y-4 text-sm text-slate-600 dark:text-slate-400">
                        <li class="flex items-start gap-3">
                            <i class="fas fa-map-marker-alt mt-1 text-slate-400"></i>
                            <span>123 Financial District,<br>Mumbai, India 400001</span>
                        </li>
                        <li class="flex items-center gap-3">
                            <i class="fas fa-phone text-slate-400"></i>
                            <span>1800-123-4567</span>
                        </li>
                        <li class="flex items-center gap-3">
                            <i class="fas fa-envelope text-slate-400"></i>
                            <span>support@acebank.com</span>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Bottom Bar -->
            <div class="border-t border-slate-200 dark:border-slate-800 py-6 text-sm text-slate-500 dark:text-slate-400 flex flex-col md:flex-row justify-between items-center gap-4">
                <p>© 2026 AceBank Limited. All rights reserved. | RBI License No. 12345</p>
                <div class="flex items-center space-x-6">
                    <a href="#" class="hover:text-blue-600 dark:hover:text-blue-400 transition-colors">Privacy</a>
                    <a href="#" class="hover:text-blue-600 dark:hover:text-blue-400 transition-colors">Terms</a>
                    <a href="#" class="hover:text-blue-600 dark:hover:text-blue-400 transition-colors">Security</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Global AceBank Scripts -->
    <script src="<%= request.getContextPath() %>/assets/js/acebank.js"></script>

    <!-- Notification Scripts -->
    <script>
        function loadNotifications() {
            fetch('<%= request.getContextPath() %>/notifications')
                .then(response => response.json())
                .then(data => {
                    const elem = document.querySelector('[x-data]');
                    // Alpine v3: read/write the component scope via Alpine.$data()
                    if (window.Alpine && typeof Alpine.$data === 'function' && elem) {
                        const scope = Alpine.$data(elem);
                        if (scope) {
                            scope.notifications = Array.isArray(data) ? data : [];
                            scope.unreadCount = scope.notifications.filter(n => !n.read).length;
                        }
                    }
                })
                .catch(error => console.error('Error loading notifications:', error));
        }

        function markAsRead(id) {
            fetch('<%= request.getContextPath() %>/notifications?action=markRead&id=' + id)
                .then(() => {
                    loadNotifications();
                })
                .catch(error => console.error('Error marking as read:', error));
        }

        function markAllAsRead() {
            fetch('<%= request.getContextPath() %>/notifications?action=markAllRead')
                .then(() => {
                    loadNotifications();
                })
                .catch(error => console.error('Error marking all as read:', error));
        }
    </script>
</body>
</html>