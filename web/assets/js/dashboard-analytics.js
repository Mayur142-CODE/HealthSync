// HealthSync - Dashboard Analytics
// Dynamic chart rendering with real-time data from backend

let appointmentChart = null;
let patientTrendChart = null;

// Initialize dashboard when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    loadDashboardAnalytics();
});

/**
 * Load analytics data from server and render charts
 */
function loadDashboardAnalytics() {
    // Show loading state
    showLoadingState();
    
    // Fetch analytics data from servlet
    fetch('../admin/dashboard?type=json')
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            // Update stat cards with animation
            updateStatCards(data.totals);
            
            // Render charts
            renderAppointmentStatusChart(data.appointmentStatus);
            renderPatientTrendChart(data.patientRegistrations);
            
            // Hide loading state
            hideLoadingState();
        })
        .catch(error => {
            console.error('Error loading analytics:', error);
            showErrorState('Failed to load dashboard analytics. Please refresh the page.');
        });
}

/**
 * Update statistic cards with animated counters
 */
function updateStatCards(totals) {
    if (!totals) return;
    
    // Animate counters
    const counters = document.querySelectorAll('.counter');
    counters.forEach(counter => {
        const target = parseInt(counter.dataset.target);
        animateCounter(counter, target, 1500);
    });
}

/**
 * Render Appointment Status Chart (Doughnut)
 */
function renderAppointmentStatusChart(statusData) {
    const canvas = document.getElementById('appointmentsChart');
    if (!canvas) return;
    
    // Get existing chart instance from Chart.js registry and destroy it
    const existingChart = Chart.getChart(canvas);
    if (existingChart) {
        existingChart.destroy();
    }
    
    // Destroy our stored reference if it exists
    if (appointmentChart) {
        appointmentChart.destroy();
        appointmentChart = null;
    }
    
    // Prepare data
    const labels = [];
    const data = [];
    const colors = {
        'Scheduled': '#17a2b8',
        'Completed': '#28a745',
        'Cancelled': '#dc3545',
        'Pending': '#ffc107'
    };
    const backgroundColors = [];
    
    for (const [status, count] of Object.entries(statusData)) {
        labels.push(status);
        data.push(count);
        backgroundColors.push(colors[status] || '#6c757d');
    }
    
    const ctx = canvas.getContext('2d');
    appointmentChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: labels,
            datasets: [{
                data: data,
                backgroundColor: backgroundColors,
                borderWidth: 2,
                borderColor: '#fff'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        padding: 15,
                        font: {
                            size: 12,
                            family: "'Inter', sans-serif"
                        },
                        usePointStyle: true,
                        pointStyle: 'circle'
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    padding: 12,
                    titleFont: {
                        size: 14,
                        weight: 'bold'
                    },
                    bodyFont: {
                        size: 13
                    },
                    callbacks: {
                        label: function(context) {
                            const label = context.label || '';
                            const value = context.parsed || 0;
                            const total = context.dataset.data.reduce((a, b) => a + b, 0);
                            const percentage = ((value / total) * 100).toFixed(1);
                            return `${label}: ${value} (${percentage}%)`;
                        }
                    }
                }
            },
            animation: {
                animateRotate: true,
                animateScale: true,
                duration: 1000
            }
        }
    });
}

/**
 * Render Patient Registration Trend Chart (Bar/Line)
 */
function renderPatientTrendChart(registrationData) {
    const canvas = document.getElementById('patientsChart');
    if (!canvas) return;
    
    // Get existing chart instance from Chart.js registry and destroy it
    const existingChart = Chart.getChart(canvas);
    if (existingChart) {
        existingChart.destroy();
    }
    
    // Destroy our stored reference if it exists
    if (patientTrendChart) {
        patientTrendChart.destroy();
        patientTrendChart = null;
    }
    
    // Prepare data
    const labels = Object.keys(registrationData);
    const data = Object.values(registrationData);
    
    const ctx = canvas.getContext('2d');
    patientTrendChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'New Patient Registrations',
                data: data,
                backgroundColor: 'rgba(32, 201, 151, 0.8)',
                borderColor: '#20c997',
                borderWidth: 2,
                borderRadius: 8,
                hoverBackgroundColor: 'rgba(32, 201, 151, 1)'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: true,
                    position: 'top',
                    labels: {
                        font: {
                            size: 12,
                            family: "'Inter', sans-serif"
                        },
                        usePointStyle: true,
                        pointStyle: 'circle'
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    padding: 12,
                    titleFont: {
                        size: 14,
                        weight: 'bold'
                    },
                    bodyFont: {
                        size: 13
                    },
                    callbacks: {
                        label: function(context) {
                            return `Registrations: ${context.parsed.y}`;
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1,
                        font: {
                            size: 11
                        }
                    },
                    grid: {
                        color: 'rgba(0, 0, 0, 0.05)'
                    }
                },
                x: {
                    ticks: {
                        font: {
                            size: 11
                        }
                    },
                    grid: {
                        display: false
                    }
                }
            },
            animation: {
                duration: 1000,
                easing: 'easeInOutQuart'
            }
        }
    });
}

/**
 * Animate counter from 0 to target value
 */
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

/**
 * Show loading state on charts
 */
function showLoadingState() {
    const chartContainers = document.querySelectorAll('.chart-container');
    chartContainers.forEach(container => {
        const loader = document.createElement('div');
        loader.className = 'chart-loader text-center py-5';
        loader.innerHTML = `
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="text-muted mt-3">Loading analytics...</p>
        `;
        container.appendChild(loader);
    });
}

/**
 * Hide loading state
 */
function hideLoadingState() {
    const loaders = document.querySelectorAll('.chart-loader');
    loaders.forEach(loader => loader.remove());
}

/**
 * Show error state
 */
function showErrorState(message) {
    hideLoadingState();
    
    const chartContainers = document.querySelectorAll('.chart-container');
    chartContainers.forEach(container => {
        const error = document.createElement('div');
        error.className = 'alert alert-danger text-center';
        error.innerHTML = `
            <i class="fas fa-exclamation-triangle me-2"></i>
            ${message}
        `;
        container.appendChild(error);
    });
}

/**
 * Refresh dashboard data
 */
function refreshDashboard() {
    // Destroy existing charts using Chart.js registry
    const appointmentsCanvas = document.getElementById('appointmentsChart');
    const patientsCanvas = document.getElementById('patientsChart');
    
    if (appointmentsCanvas) {
        const existingChart = Chart.getChart(appointmentsCanvas);
        if (existingChart) existingChart.destroy();
    }
    
    if (patientsCanvas) {
        const existingChart = Chart.getChart(patientsCanvas);
        if (existingChart) existingChart.destroy();
    }
    
    // Clear stored references
    appointmentChart = null;
    patientTrendChart = null;
    
    // Reload analytics
    loadDashboardAnalytics();
}

// Export functions for global access
window.refreshDashboard = refreshDashboard;
