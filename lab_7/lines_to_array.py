# Read numbers from the input file and write them in a single line in the output file
def process_numbers(input_file, output_file):
    with open(input_file, 'r') as infile:
        # Read lines and strip newline characters
        numbers = [line.strip() for line in infile]

    # Join the numbers with commas
    output_line = ','.join(numbers)

    # Write the single line to the output file
    with open(output_file, 'w') as outfile:
        outfile.write(output_line)

# Specify your input and output file names
input_file = 'bayer16x16_2024.txt'
output_file = 'bayer16x16_sdk.txt'

# Process the numbers
process_numbers(input_file, output_file)

print(f"Numbers from {input_file} have been written to {output_file} in a single line.")
