conda env create -f environment.yml && conda activate arf-svox2
# install customized cuda kernels
# pip install . --upgrade --use-feature=in-tree-build

pip install torch==1.11.0+cu113 torchvision==0.12.0+cu113 --extra-index-url https://download.pytorch.org/whl/cu113
# pip install numpy==1.20
pip install . --upgrade 
pip install icecream
pip install git+https://github.com/openai/CLIP.git
