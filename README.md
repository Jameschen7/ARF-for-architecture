# ARF: Artistic Radiance Fields
![](./resources/fortress_brutal.mp4)

<img src="./resources/fortress_milan.mp4" width="200">
<img src="./resources/fortress_japanese.mp4" width="200px">

## Quick start

### Install environment
```bash
. ./create_env.sh
```
### Download data
```bash
. ./download_data.sh
```
### Optimize artistic radiance fields
```bash
cd opt && . ./try_{llff/tnt/custom}.sh [scene_name] [style_id]
```
* Select ```{llff/tnt/custom}``` according to your data type. For example, use ```llff``` for ```flower``` scene, ```tnt``` for ```Playground``` scene, and ```custom``` for ```lego``` scene. 
* ```[style_id].jpg``` is the style image inside ```./data/styles```. For example, ```14.jpg``` is the starry night painting.
* Note that a photorealistic radiance field will first be reconstructed for each scene, if it doesn't exist on disk. This will take extra time.

### Check results
The optimized artistic radiance field is inside ```opt/ckpt_arf/[scene_name]_[style_id]```, while the photorealistic one is inside ```opt/ckpt_svox2/[scene_name]```.

### Custom data
Please follow the steps on [Plenoxel](https://github.com/sxyu/svox2) to prepare your own custom data.

### More information
For more information and details, we refer you to check [Plenoxel](https://github.com/sxyu/svox2) and [ARF](https://github.com/Kai-46/ARF-svox2) GitHub pages.

## Acknowledgement:
We would like to thank the following authors for open-sourcing their implementations:
* [Plenoxel](https://github.com/sxyu/svox2)
* [ARF](https://github.com/Kai-46/ARF-svox2) 
  * Project page: <https://www.cs.cornell.edu/projects/arf/>
  * ![](./resources/ARF.mov)
