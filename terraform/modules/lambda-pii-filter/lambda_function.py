import json
import re
import base64

def lambda_handler(event, context):
    """
    Lambda function to filter PII from CloudWatch Logs
    """
    
    # PII patterns to detect and redact
    pii_patterns = {
        'EMAIL': r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
        'PHONE': r'\b\d{3}[-.]?\d{3}[-.]?\d{4}\b',
        'CREDIT_CARD': r'\b\d{4}[- ]?\d{4}[- ]?\d{4}[- ]?\d{4}\b',
        'SSN': r'\b\d{3}-\d{2}-\d{4}\b',
        'IP_ADDRESS': r'\b(?:\d{1,3}\.){3}\d{1,3}\b'
    }
    
    output = []
    
    for record in event.get('records', []):
        try:
            # Decode the data
            data = base64.b64decode(record['data']).decode('utf-8')
            
            # Parse JSON log entry
            log_entry = json.loads(data)
            
            # Redact PII from message field
            if 'message' in log_entry:
                message = log_entry['message']
                for pii_type, pattern in pii_patterns.items():
                    message = re.sub(pattern, f'[{pii_type}_REDACTED]', message)
                log_entry['message'] = message
            
            # Redact PII from other string fields
            for key, value in log_entry.items():
                if isinstance(value, str) and key != 'message':
                    for pii_type, pattern in pii_patterns.items():
                        value = re.sub(pattern, f'[{pii_type}_REDACTED]', value)
                    log_entry[key] = value
            
            # Encode back
            processed_data = base64.b64encode(json.dumps(log_entry).encode('utf-8')).decode('utf-8')
            
            output.append({
                'recordId': record['recordId'],
                'result': 'Ok',
                'data': processed_data
            })
            
        except Exception as e:
            # If processing fails, return the original record
            output.append({
                'recordId': record['recordId'],
                'result': 'ProcessingFailed',
                'data': record['data']
            })
    
    print(f"Processed {len(output)} records")
    return {'records': output}
