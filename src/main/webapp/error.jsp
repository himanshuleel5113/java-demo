<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${errorTitle} - AceBank</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/acebank.css">
</head>
<body class="bg-slate-50 dark:bg-slate-900 text-slate-900 dark:text-slate-100 antialiased font-sans flex flex-col min-h-screen">
    <header class="glass-header sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
            <a href="index.jsp" class="flex items-center gap-2 group w-max">
                <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-blue-600 to-indigo-600 flex items-center justify-center text-white shadow-lg group-hover:scale-105 transition-transform">
                    <i class="fas fa-university text-xl"></i>
                </div>
                <span class="text-2xl font-brand font-bold tracking-tight">
                    <span class="text-slate-900 dark:text-white">Ace</span><span class="text-blue-600 dark:text-blue-400">Bank</span>
                </span>
            </a>
        </div>
    </header>

    <div class="flex-1 flex items-center justify-center py-12 px-4 relative overflow-hidden">
        <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[800px] bg-red-500/10 rounded-full blur-3xl pointer-events-none"></div>

        <div class="max-w-2xl w-full page-enter relative z-10">
            <div class="glass-panel rounded-3xl p-10 md:p-16 text-center shadow-2xl border-t-4 border-red-500">
                <div class="mb-8 relative inline-block">
                    <div class="absolute inset-0 bg-red-500/20 blur-2xl rounded-full"></div>
                    <i class="fas fa-exclamation-triangle text-8xl relative z-10 ${errorCode == 404 ? 'text-amber-500 drop-shadow-[0_0_15px_rgba(245,158,11,0.5)]' : 'text-red-500 drop-shadow-[0_0_15px_rgba(239,68,68,0.5)]'}"></i>
                </div>
                
                <div class="relative">
                    <p class="text-[10rem] font-brand font-black leading-none text-slate-200 dark:text-slate-800/50 absolute left-1/2 -translate-x-1/2 top-1/2 -translate-y-1/2 -z-10 select-none">${errorCode}</p>
                    <h2 class="text-4xl font-brand font-bold text-slate-900 dark:text-white mb-4">${errorTitle}</h2>
                    <p class="text-lg text-slate-600 dark:text-slate-400 mb-10 max-w-lg mx-auto">${errorMessage}</p>
                </div>

                <div class="flex flex-col sm:flex-row gap-4 justify-center">
                    <a href="javascript:history.back()" class="btn-secondary py-4 px-8 text-lg flex items-center justify-center gap-2">
                        <i class="fas fa-arrow-left text-sm"></i> Go Back
                    </a>
                    <a href="home" class="btn-primary py-4 px-8 text-lg flex items-center justify-center gap-2 shadow-lg shadow-blue-600/30">
                        <i class="fas fa-home text-sm"></i> Dashboard
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>