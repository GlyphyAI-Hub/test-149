import json

def file_to_safe_json_string(filepath: str) -> str:
    try:
        # Open and read the file content
        with open(filepath, 'r', encoding='utf-8') as file:
            content = file.read()
        
        # Convert content to a safe JSON string
        safe_string = json.dumps(content)
        
        return safe_string
    except Exception as e:
        print(f"An error occurred: {e}")
        return None

# Example usage
filepath = "/Users/mozharovsky/Developer/glyphy-fs/playgrounds/Playground_02/broken.dart"
safe_json_string = file_to_safe_json_string(filepath)

if safe_json_string:
    print(f"Safe JSON string: {safe_json_string}")