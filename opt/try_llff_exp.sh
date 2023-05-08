train_opt_arf()
{
    SCENE=$1
    STYLE=$2
    suffix="_$3" # the third argument is also used as the config name
    echo "<--------------train_opt_arf [SCENE:$1 STYLE:$2,suffix:${suffix}] -------------->"

    data_type=llff
    ckpt_svox2=ckpt_svox2/${data_type}/${SCENE}
    ckpt_arf=ckpt_arf/${data_type}/${SCENE}_${STYLE}${suffix}
    data_dir=../data/${data_type}/${SCENE}
    style_img=../data/styles/${STYLE}.jpg


    if [[ ! -f "${ckpt_svox2}/ckpt.npz" ]]; then
        python opt.py -t ${ckpt_svox2} ${data_dir} \
                        -c configs/llff.json
        python render_imgs.py ${ckpt_svox2}/ckpt.npz ${data_dir} --render_path 
    fi

    # python opt_style.py -t ${ckpt_arf} ${data_dir} \
    #                 -c configs/llff_geom.json \
    #                 --init_ckpt ${ckpt_svox2}/ckpt.npz \
    #                 --style ${style_img} \
    #                 --mse_num_epoches 2 --nnfm_num_epoches 10 \
    #                 --content_weight 1e-3 
    echo -e '\n--- opt_style.py'
    python opt_style.py -t ${ckpt_arf} ${data_dir} \
                    -c configs/llff_$3.json \
                    --init_ckpt ${ckpt_svox2}/ckpt.npz \
                    --style ${style_img} \
                    --mse_num_epoches 2 --nnfm_num_epoches 10 \
                    --content_weight 1e-3 

    echo -e '\n--- render_imgs.py'
    python render_imgs.py ${ckpt_arf}/ckpt.npz ${data_dir} \
                        --render_path #--no_imsave
}

## experiements
# train_opt_arf fortress milan2 geom3e2
# train_opt_arf fortress milan2 geom1e2Clip0.1
# train_opt_arf fortress milan2 geom1e2Clip0.01
# train_opt_arf fortress milan2 geom1e2Clip0.1NegStyle
# train_opt_arf fortress milan2 geom1e2Clip0.1TNegStyles
# train_opt_arf fortress milan2 geom1e2Clip1TNegStyles
# train_opt_arf fortress milan2 geom1e2Clip1TNegStyles
# train_opt_arf fortress milan2 geom1e3Clip1TNegStylesTV1
# train_opt_arf fortress milan2 geom3e3Clip0.5TNegStylesTV5
# train_opt_arf fortress milan2 geom3e4Clip0.5TNegStylesTV5Long


# train_opt_arf fortress milan2 geom3e3Clip0.5TNegStylesTV7
# train_opt_arf fortress milan2 geom3e3Clip0.5TNegStylesTV4
# train_opt_arf fortress milan2 geom3e3Clip0.5TNegStylesLargeBlurTV5
train_opt_arf fortress milan2 geom3e3Clip0.5TNegStylesLargeTV5