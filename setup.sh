#!/bin/bash

# Set up environment
echo "Updating system packages..."
sudo apt update && sudo apt install -y python3 python3-pip python3-venv git build-essential

# Create virtual environment
echo "Creating Python virtual environment..."
python3 -m venv pointnet_env
source pointnet_env/bin/activate

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip setuptools wheel

# Install TensorFlow (choose CPU or GPU version)
echo "Installing TensorFlow..."
pip install tensorflow  # For GPU support; use 'tensorflow-cpu' if no GPU

# Clone PointNet++ repository
echo "Cloning PointNet++ repository..."
git clone https://github.com/charlesq34/pointnet2.git
cd pointnet2 || exit

# Install Python dependencies
echo "Installing Python dependencies..."
pip install numpy h5py matplotlib

# Compile TensorFlow custom operations
echo "Compiling TensorFlow custom operations..."
cd tf_ops || exit
for d in grouping sampling 3d_interpolation; do
  echo "Compiling $d..."
  cd $d || exit
  python setup.py build_ext --inplace
  cd ..
done

# Test TensorFlow GPU setup
echo "Checking TensorFlow GPU availability..."
python -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"

# Final message
echo "PointNet++ setup complete. You can now train models!"
