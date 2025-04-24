import sys
import os

def convert_html_to_php_with_color(html_file_path):
    """
    Prepends PHP code to an HTML file and replaces all occurrences of "green"
    with "<?php echo $color; ?>", outputting the result to a .php file
    with the same name (but .php extension).

    Args:
        html_file_path (str): The path to the input HTML file.
    """
    if not os.path.exists(html_file_path):
        print(f"Error: HTML file not found at '{html_file_path}'")
        return

    php_prepend = """<?php
$color = 'teal';
// Options:
// amber aqua blue light-blue brown cyan blue-grey green
// light-green indigo khaki lime orange deep-orange pink
// purple deep-purple red sand teal yellow white black
// grey light-grey dark-grey

?>
"""

    try:
        with open(html_file_path, 'r') as f:
            html_content = f.read()

        modified_content = html_content.replace('green', '<?php echo $color; ?>')
        final_content = php_prepend + modified_content

        php_file_path = os.path.splitext(html_file_path)[0] + ".php"

        with open(php_file_path, 'w') as f:
            f.write(final_content)

        print(f"Successfully created '{php_file_path}' with prepended PHP and replaced 'green'.")

    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script_name.py <html_file_path>")
    else:
        html_file = sys.argv[1]
        convert_html_to_php_with_color(html_file)
