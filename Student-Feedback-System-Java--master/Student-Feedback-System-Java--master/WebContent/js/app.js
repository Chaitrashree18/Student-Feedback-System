/**
 * Student Feedback System - JavaScript
 * Handles dynamic form building (AJAX) and client-side validation.
 */

// ==================== FORM BUILDER (Admin) ====================

/**
 * Show/hide the MCQ options field based on question type selection.
 */
function toggleOptionsField() {
    var questionType = document.getElementById('questionType');
    var optionsGroup = document.getElementById('optionsGroup');
    if (questionType && optionsGroup) {
        if (questionType.value === 'MCQ') {
            optionsGroup.style.display = 'block';
        } else {
            optionsGroup.style.display = 'none';
        }
    }
}

/**
 * Add a question to the form using AJAX.
 */
function addQuestionAjax(event) {
    event.preventDefault();

    var formId = document.getElementById('formId').value;
    var questionText = document.getElementById('questionText').value.trim();
    var questionType = document.getElementById('questionType').value;
    var options = document.getElementById('options') ? document.getElementById('options').value.trim() : '';

    // Validation
    if (!questionText) {
        showAlert('danger', 'Please enter the question text.');
        return;
    }
    if (questionType === 'MCQ' && !options) {
        showAlert('danger', 'Please enter options for Multiple Choice question (comma-separated).');
        return;
    }

    // Build form data
    var params = 'formId=' + encodeURIComponent(formId)
               + '&questionText=' + encodeURIComponent(questionText)
               + '&questionType=' + encodeURIComponent(questionType)
               + '&options=' + encodeURIComponent(options)
               + '&ajax=true';

    // AJAX request
    var xhr = new XMLHttpRequest();
    xhr.open('POST', document.getElementById('addQuestionForm').action, true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            if (xhr.status === 200) {
                var result = JSON.parse(xhr.responseText);
                if (result.success) {
                    showAlert('success', 'Question added successfully!');
                    // Reload the page to show the new question
                    setTimeout(function() {
                        window.location.reload();
                    }, 500);
                } else {
                    showAlert('danger', result.message || 'Failed to add question.');
                }
            } else {
                showAlert('danger', 'Server error. Please try again.');
            }
        }
    };

    xhr.send(params);
}

/**
 * Confirm before deleting a question.
 */
function confirmDeleteQuestion(url) {
    if (confirm('Are you sure you want to delete this question?')) {
        window.location.href = url;
    }
}

/**
 * Confirm before deleting a form.
 */
function confirmDeleteForm(url) {
    if (confirm('Are you sure you want to delete this form? All questions and responses will be permanently removed.')) {
        window.location.href = url;
    }
}

// ==================== STUDENT FORM VALIDATION ====================

/**
 * Validate the student feedback form before submission.
 */
function validateFeedbackForm(event) {
    var form = event.target;
    var requiredFields = form.querySelectorAll('[required]');
    var isValid = true;

    for (var i = 0; i < requiredFields.length; i++) {
        var field = requiredFields[i];
        if (!field.value || field.value.trim() === '') {
            field.classList.add('is-invalid');
            isValid = false;
        } else {
            field.classList.remove('is-invalid');
            field.classList.add('is-valid');
        }
    }

    // Check radio button groups
    var radioGroups = {};
    var radios = form.querySelectorAll('input[type="radio"][required]');
    for (var j = 0; j < radios.length; j++) {
        radioGroups[radios[j].name] = true;
    }
    for (var groupName in radioGroups) {
        var checked = form.querySelector('input[name="' + groupName + '"]:checked');
        if (!checked) {
            isValid = false;
            var radioContainer = form.querySelector('input[name="' + groupName + '"]').closest('.question-card');
            if (radioContainer) {
                radioContainer.style.borderColor = '#e74a3b';
            }
        }
    }

    if (!isValid) {
        event.preventDefault();
        showAlert('danger', 'Please answer all required questions before submitting.');
    }

    return isValid;
}

// ==================== UTILITY ====================

/**
 * Show a Bootstrap alert at the top of the main content area.
 */
function showAlert(type, message) {
    var alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-' + type + ' alert-dismissible fade show';
    alertDiv.setAttribute('role', 'alert');
    alertDiv.innerHTML = message
        + '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';

    var container = document.querySelector('.container') || document.querySelector('.container-fluid');
    if (container) {
        container.insertBefore(alertDiv, container.firstChild);
    }

    // Auto-dismiss after 4 seconds
    setTimeout(function() {
        if (alertDiv.parentNode) {
            alertDiv.remove();
        }
    }, 4000);
}

// ==================== INITIALIZE ====================

document.addEventListener('DOMContentLoaded', function() {
    // Initialize options toggle for form builder
    var questionType = document.getElementById('questionType');
    if (questionType) {
        questionType.addEventListener('change', toggleOptionsField);
        toggleOptionsField(); // Set initial state
    }

    // Initialize AJAX form submission
    var addQuestionForm = document.getElementById('addQuestionForm');
    if (addQuestionForm) {
        addQuestionForm.addEventListener('submit', addQuestionAjax);
    }

    // Initialize feedback form validation
    var feedbackForm = document.getElementById('feedbackForm');
    if (feedbackForm) {
        feedbackForm.addEventListener('submit', validateFeedbackForm);
    }
});
