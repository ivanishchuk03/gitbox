from PIL import Image
import os

# Load the image
image_path = '2020-0042.jpg'
image = Image.open(image_path)

# Check the current file size
current_size = os.path.getsize(image_path) / (1024 * 1024)  # size in MB
current_size
# Save the image with a higher quality to increase the size to around 0.9 MB
new_image_path = 'resized_2020-0042.jpg'
image.save(new_image_path, quality=50)

# Check the new file size
new_size = os.path.getsize(new_image_path) / (1024 * 1024)  # size in MB
print(new_size)
print('OK')
