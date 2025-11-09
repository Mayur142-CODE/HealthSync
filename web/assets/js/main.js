// HealthSync - Main JavaScript File

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    initializeApp();
});

// Main initialization function
function initializeApp() {
    initializeTooltips();
    initializePopovers();
    initializeDataTables();
    initializeCharts();
    initializeDatePickers();
    initializeFormValidation();
    initializeAjaxSearch();
    initializeNotifications();
}

// Initialize Bootstrap tooltips
function initializeTooltips() {
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function(tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
}

// Initialize Bootstrap popovers
function initializePopovers() {
    var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
    var popoverList = popoverTriggerList.map(function(popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl);
    });
}

// Initialize DataTables (if available)
function initializeDataTables() {
    if (typeof $ !== 'undefined' && $.fn.DataTable) {
        $('.data-table').DataTable({
            responsive: true,
            pageLength: 10,
            lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
            order: [[0, 'desc']],
            language: {
                search: "Search:",
                lengthMenu: "Show _MENU_ entries",
                info: "Showing _START_ to _END_ of _TOTAL_ entries",
                paginate: {
                    first: "First",
                    last: "Last",
                    next: "Next",
                    previous: "Previous"
                }
            }
        });
    }
}

// Initialize Charts (Chart.js)
function initializeCharts() {
    // Skip chart initialization if dashboard-analytics.js is loaded (it will handle charts)
    if (typeof loadDashboardAnalytics === 'function') {
        return;
    }
    
    // Appointments Chart
    const appointmentsChart = document.getElementById('appointmentsChart');
    if (appointmentsChart) {
        // Check if chart already exists
        const existingChart = Chart.getChart(appointmentsChart);
        if (existingChart) {
            return; // Don't create duplicate chart
        }
        
        const ctx = appointmentsChart.getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Pending', 'Approved', 'Completed', 'Cancelled'],
                datasets: [{
                    data: [12, 25, 18, 5],
                    backgroundColor: [
                        '#ffc107',
                        '#28a745',
                        '#17a2b8',
                        '#6c757d'
                    ],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    }

    // Patients Trend Chart
    const patientsChart = document.getElementById('patientsChart');
    if (patientsChart) {
        // Check if chart already exists
        const existingChart = Chart.getChart(patientsChart);
        if (existingChart) {
            return; // Don't create duplicate chart
        }
        
        const ctx = patientsChart.getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                datasets: [{
                    label: 'New Patients',
                    data: [12, 19, 15, 25, 22, 30],
                    borderColor: '#20c997',
                    backgroundColor: 'rgba(32, 201, 151, 0.1)',
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }
}

// Initialize date pickers
function initializeDatePickers() {
    const dateInputs = document.querySelectorAll('input[type="date"]');
    dateInputs.forEach(input => {
        // Set min date to today for appointment booking
        if (input.name === 'appointmentDate') {
            const today = new Date().toISOString().split('T')[0];
            input.min = today;
        }
    });
}

// Form validation
function initializeFormValidation() {
    const forms = document.querySelectorAll('.needs-validation');
    
    Array.prototype.slice.call(forms).forEach(function(form) {
        form.addEventListener('submit', function(event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    });

    // Password confirmation validation
    const passwordInputs = document.querySelectorAll('input[name="password"]');
    const confirmPasswordInputs = document.querySelectorAll('input[name="confirmPassword"]');
    
    confirmPasswordInputs.forEach(confirmInput => {
        confirmInput.addEventListener('input', function() {
            const passwordInput = document.querySelector('input[name="password"]');
            if (passwordInput && passwordInput.value !== this.value) {
                this.setCustomValidity('Passwords do not match');
            } else {
                this.setCustomValidity('');
            }
        });
    });
}

// AJAX Search functionality
function initializeAjaxSearch() {
    const searchInputs = document.querySelectorAll('.ajax-search');
    
    searchInputs.forEach(input => {
        let timeout;
        input.addEventListener('input', function() {
            clearTimeout(timeout);
            timeout = setTimeout(() => {
                performAjaxSearch(this.value, this.dataset.target);
            }, 300);
        });
    });
}

// Perform AJAX search
function performAjaxSearch(query, target) {
    if (query.length < 2) return;
    
    fetch(`/HealthSync/api/search?q=${encodeURIComponent(query)}&type=${target}`)
        .then(response => response.json())
        .then(data => {
            displaySearchResults(data, target);
        })
        .catch(error => {
            console.error('Search error:', error);
        });
}

// Display search results
function displaySearchResults(results, target) {
    const resultsContainer = document.getElementById(`${target}Results`);
    if (!resultsContainer) return;
    
    resultsContainer.innerHTML = '';
    
    if (results.length === 0) {
        resultsContainer.innerHTML = '<div class="alert alert-info">No results found</div>';
        return;
    }
    
    results.forEach(item => {
        const resultItem = createResultItem(item, target);
        resultsContainer.appendChild(resultItem);
    });
}

// Create result item element
function createResultItem(item, type) {
    const div = document.createElement('div');
    div.className = 'list-group-item list-group-item-action';
    
    switch(type) {
        case 'doctors':
            div.innerHTML = `
                <div class="d-flex w-100 justify-content-between">
                    <h6 class="mb-1">Dr. ${item.firstName} ${item.lastName}</h6>
                    <small class="text-muted">${item.specialization}</small>
                </div>
                <p class="mb-1">${item.qualification}</p>
                <small class="text-muted">${item.experience} years experience</small>
            `;
            break;
        case 'patients':
            div.innerHTML = `
                <div class="d-flex w-100 justify-content-between">
                    <h6 class="mb-1">${item.firstName} ${item.lastName}</h6>
                    <small class="text-muted">${item.phone}</small>
                </div>
                <p class="mb-1">${item.email}</p>
                <small class="text-muted">Blood Group: ${item.bloodGroup}</small>
            `;
            break;
    }
    
    return div;
}

// Notification system
function initializeNotifications() {
    // Auto-hide alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert:not(.alert-permanent)');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });
}

// Show toast notification
function showToast(message, type = 'info') {
    const toastContainer = document.getElementById('toastContainer') || createToastContainer();
    
    const toast = document.createElement('div');
    toast.className = `toast align-items-center text-white bg-${type} border-0`;
    toast.setAttribute('role', 'alert');
    toast.innerHTML = `
        <div class="d-flex">
            <div class="toast-body">
                ${message}
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    `;
    
    toastContainer.appendChild(toast);
    
    const bsToast = new bootstrap.Toast(toast);
    bsToast.show();
    
    // Remove toast after it's hidden
    toast.addEventListener('hidden.bs.toast', () => {
        toast.remove();
    });
}

// Create toast container if it doesn't exist
function createToastContainer() {
    const container = document.createElement('div');
    container.id = 'toastContainer';
    container.className = 'toast-container position-fixed top-0 end-0 p-3';
    document.body.appendChild(container);
    return container;
}

// Confirm delete action
function confirmDelete(message = 'Are you sure you want to delete this item?') {
    return confirm(message);
}

// Format date for display
function formatDate(dateString) {
    const options = { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
    };
    return new Date(dateString).toLocaleDateString('en-US', options);
}

// Format time for display
function formatTime(timeString) {
    const options = { 
        hour: '2-digit', 
        minute: '2-digit',
        hour12: true
    };
    return new Date(`2000-01-01T${timeString}`).toLocaleTimeString('en-US', options);
}

// Show loading spinner
function showLoading(element) {
    const originalContent = element.innerHTML;
    element.innerHTML = '<span class="loading-spinner"></span> Loading...';
    element.disabled = true;
    
    return function hideLoading() {
        element.innerHTML = originalContent;
        element.disabled = false;
    };
}

// Animate counter numbers
function animateCounter(element, target, duration = 2000) {
    let start = 0;
    const increment = target / (duration / 16);
    
    const timer = setInterval(() => {
        start += increment;
        element.textContent = Math.floor(start);
        
        if (start >= target) {
            element.textContent = target;
            clearInterval(timer);
        }
    }, 16);
}

// Initialize counter animations when element is visible
function initializeCounters() {
    const counters = document.querySelectorAll('.counter');
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const target = parseInt(entry.target.dataset.target);
                animateCounter(entry.target, target);
                observer.unobserve(entry.target);
            }
        });
    });
    
    counters.forEach(counter => {
        observer.observe(counter);
    });
}

// Print functionality
function printPage() {
    window.print();
}

// Export to PDF (requires jsPDF library)
function exportToPDF(elementId, filename = 'document.pdf') {
    if (typeof jsPDF === 'undefined') {
        console.error('jsPDF library not loaded');
        return;
    }
    
    const element = document.getElementById(elementId);
    if (!element) {
        console.error('Element not found:', elementId);
        return;
    }
    
    html2canvas(element).then(canvas => {
        const imgData = canvas.toDataURL('image/png');
        const pdf = new jsPDF();
        const imgWidth = 210;
        const pageHeight = 295;
        const imgHeight = (canvas.height * imgWidth) / canvas.width;
        let heightLeft = imgHeight;
        
        let position = 0;
        
        pdf.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
        heightLeft -= pageHeight;
        
        while (heightLeft >= 0) {
            position = heightLeft - imgHeight;
            pdf.addPage();
            pdf.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
            heightLeft -= pageHeight;
        }
        
        pdf.save(filename);
    });
}

// Utility functions
const Utils = {
    // Debounce function
    debounce: function(func, wait, immediate) {
        let timeout;
        return function executedFunction() {
            const context = this;
            const args = arguments;
            const later = function() {
                timeout = null;
                if (!immediate) func.apply(context, args);
            };
            const callNow = immediate && !timeout;
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
            if (callNow) func.apply(context, args);
        };
    },
    
    // Throttle function
    throttle: function(func, limit) {
        let inThrottle;
        return function() {
            const args = arguments;
            const context = this;
            if (!inThrottle) {
                func.apply(context, args);
                inThrottle = true;
                setTimeout(() => inThrottle = false, limit);
            }
        };
    },
    
    // Generate random ID
    generateId: function() {
        return '_' + Math.random().toString(36).substr(2, 9);
    },
    
    // Validate email
    validateEmail: function(email) {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(email);
    },
    
    // Validate phone number
    validatePhone: function(phone) {
        const re = /^[\+]?[1-9][\d]{0,15}$/;
        return re.test(phone);
    }
};

// Global error handler
window.addEventListener('error', function(e) {
    console.error('Global error:', e.error);
    showToast('An unexpected error occurred. Please try again.', 'danger');
});

// Initialize counters when page loads
document.addEventListener('DOMContentLoaded', function() {
    initializeCounters();
});
