/**
 * AceBank Global JavaScript Module
 */

document.addEventListener('DOMContentLoaded', () => {
    // Apply page transition animation
    const mainContent = document.querySelector('.main-content') || document.querySelector('main');
    if (mainContent) {
        mainContent.classList.add('page-enter');
    }
});

// Utility functions that can be used globally
const AceBank = {
    // Format currency to INR
    formatCurrency: function(amount) {
        return new Intl.NumberFormat('en-IN', {
            style: 'currency',
            currency: 'INR'
        }).format(amount);
    },
    
    // Validate email
    isValidEmail: function(email) {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(email);
    },
    
    // Copy to clipboard with toast notification
    copyToClipboard: function(text, successMessage = 'Copied to clipboard!') {
        navigator.clipboard.writeText(text).then(() => {
            this.showToast(successMessage, 'success');
        }).catch(err => {
            console.error('Could not copy text: ', err);
            this.showToast('Failed to copy', 'error');
        });
    },
    
    // Simple toast notification system
    showToast: function(message, type = 'info') {
        const toast = document.createElement('div');
        
        // Base styles
        toast.className = 'fixed bottom-4 right-4 px-6 py-3 rounded-xl shadow-lg transform transition-all duration-300 translate-y-10 opacity-0 z-50 flex items-center gap-3 glass-panel';
        
        // Icon based on type
        let icon = '<i class="fas fa-info-circle text-blue-500"></i>';
        if (type === 'success') icon = '<i class="fas fa-check-circle text-green-500"></i>';
        if (type === 'error') icon = '<i class="fas fa-exclamation-circle text-red-500"></i>';
        
        toast.innerHTML = `
            ${icon}
            <span class="font-medium text-sm">${message}</span>
        `;
        
        document.body.appendChild(toast);
        
        // Animate in
        setTimeout(() => {
            toast.classList.remove('translate-y-10', 'opacity-0');
            toast.classList.add('translate-y-0', 'opacity-100');
        }, 10);
        
        // Animate out and remove
        setTimeout(() => {
            toast.classList.remove('translate-y-0', 'opacity-100');
            toast.classList.add('translate-y-10', 'opacity-0');
            setTimeout(() => toast.remove(), 300);
        }, 3000);
    }
};

window.AceBank = AceBank;
