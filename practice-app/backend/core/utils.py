def format_response(status, message=None, data=None):
    """
    Format a consistent API response structure
    
    Args:
        status (str): 'success' or 'error'
        message (str, optional): Response message
        data (dict, optional): Response data
        
    Returns:
        dict: Formatted response dictionary
    """
    response = {'status': status}
    
    if message:
        response['message'] = message
        
    if data:
        response['data'] = data
        
    return response


def custom_exception_handler(exc, context):
    """
    Custom exception handler for consistent error responses.
    """
    from rest_framework.views import exception_handler
    from rest_framework.response import Response
    from rest_framework import status
    
    # Call REST framework's default exception handler first
    response = exception_handler(exc, context)
    
    # If response is None, there was an unhandled exception
    if response is None:
        return Response(
            format_response(
                status='error',
                message='An unexpected error occurred.',
            ),
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )
    
    # Format the response to match our API response structure
    error_data = {}
    if hasattr(exc, 'detail'):
        if isinstance(exc.detail, dict):
            error_data = exc.detail
        elif isinstance(exc.detail, list):
            error_data = {'detail': exc.detail}
        else:
            error_data = {'detail': str(exc.detail)}
    
    response.data = format_response(
        status='error',
        message=str(exc),
        data=error_data if error_data else None
    )
    
    return response