train_opt_arf()
{
    echo "<--------------train_opt_arf [SCENE:$1 STYLE:$2, block:$3] -------------->"
    SCENE=$1
    STYLE=$2
    suffix="_block$3"

    echo "name: ${SCENE}_${STYLE}${suffix}"

    data_type=tnt
    ckpt_svox2=ckpt_svox2/${data_type}/${SCENE}
    # ckpt_svox2=ckpt_svox2/pretrain_tnt/${SCENE}
    ckpt_arf=ckpt_arf/${data_type}/${SCENE}_${STYLE}${suffix}
    data_dir=../data/${data_type}/${SCENE}
    style_img=../data/styles/${STYLE}.jpg


    # if [[ ! -f "${ckpt_svox2}/ckpt.npz" ]]; then
    #     python opt.py -t ${ckpt_svox2} ${data_dir} \
    #                 -c configs/tnt.json
    # fi
    if [[ ! -f "${ckpt_svox2}/ckpt.npz" ]]; then
        python opt.py -t ${ckpt_svox2} ${data_dir} \
                    -c configs/tnt_low_reso.json 
    fi

    echo -e '\n--- opt_style.py'
    # python opt_style.py -t ${ckpt_arf} ${data_dir} \
    #                 # -c configs/tnt_fixgeom_low_reso.json  \
    #                 -c configs/tnt_fixgeom.json  \
    #                 --init_ckpt ${ckpt_svox2}/ckpt.npz \
    #                 --style ${style_img} \
    #                 --mse_num_epoches 1 --nnfm_num_epoches 10 \
    #                 --content_weight 5e-3 \
    python opt_style.py -t ${ckpt_arf} ${data_dir} \
                    -c configs/tnt_fixgeom.json  \
                    --init_ckpt ${ckpt_svox2}/ckpt.npz \
                    --style ${style_img} \
                    --mse_num_epoches 1 --nnfm_num_epoches 10 \
                    --content_weight 5e-3 \
                    --vgg_block $3


    echo -e '\n--- render_imgs.py'
    python render_imgs.py ${ckpt_arf}/ckpt.npz  ${data_dir} \
                    --render_path #--no_imsave

    # python render_imgs_circle.py ckpt_svox2/tnt/Playground/ckpt.npz ../data/tnt/Playground --traj_type spiral
    # python render_imgs_circle.py ${ckpt_arf}/ckpt.npz ${data_dir} --traj_type circle
}

### command to run
# source try_tnt.sh Playground 14

### command to change to block 4, on milan Cathedral
# source try_tnt.sh Playground milan '_block3'
train_opt_arf Playground milan 1
train_opt_arf Playground milan 2
train_opt_arf Playground milan 4