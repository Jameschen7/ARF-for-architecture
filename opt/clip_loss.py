import torch
import clip
from torchvision import transforms

class CLIPLoss(torch.nn.Module):

    def __init__(self):
        super(CLIPLoss, self).__init__()
        self.model, _ = clip.load("ViT-B/32", device="cuda")
        """
        Compose(
            Resize(size=224, interpolation=bicubic, max_size=None, antialias=None)
            CenterCrop(size=(224, 224))
            <function _convert_image_to_rgb at 0x7ff4085845e0>
            ToTensor()
            Normalize(mean=(0.48145466, 0.4578275, 0.40821073), std=(0.26862954, 0.26130258, 0.27577711))
        )
        """
        self.preprocess = transforms.Compose([
            transforms.Resize(size=224, interpolation=transforms.InterpolationMode.BICUBIC, 
                              antialias=True),
            transforms.CenterCrop(size=(224, 224)),
            transforms.Normalize(mean=(0.48145466, 0.4578275, 0.40821073), 
                                 std=(0.26862954, 0.26130258, 0.27577711))
        ])
        #self.upsample = torch.nn.Upsample(scale_factor=7)
        #self.avg_pool = torch.nn.AvgPool2d(kernel_size=opts.stylegan_size // 32)

    # def forward(self, image, text):
    #     image = torch.nn.functional.upsample_bilinear(image, (224, 224))
    #     #image = self.avg_pool(self.upsample(image))
    #     similarity = 1 - self.model(image, text)[0] / 100
    #     return similarity.mean()
    
    def relative_clip_loss(self, image, text, image_orig, text_orig):
        # image = torch.nn.functional.upsample_bilinear(image, (224, 224))
        # image_orig = torch.nn.functional.upsample_bilinear(image_orig, (224, 224))

        #image = self.avg_pool(self.upsample(image))
        # pred_sim =  self.model(image, text-text_orig)- self.model(image_orig, text-text_orig)
        pred_sim =  self.model(image, text)[0]-self.model(image, text_orig)[0]- \
            self.model(image_orig, text)[0]+ self.model(image_orig, text_orig)[0]
        #self.model(image-image_orig, text-text_orig)
        similarity = 1 - pred_sim / 100
        return similarity.mean()
    
    def global_contrastive_loss(self, image, text, text_neg):
        # image = torch.nn.functional.upsample_bilinear(image, (224, 224))
        
        pos_dot = torch.exp(self.model(image, text)[0]/100 / 0.07)
        neg_dot = torch.sum(torch.exp(self.model(image, text_neg)[0]/100 / 0.07))
        con_loss = -torch.log(pos_dot / (pos_dot + neg_dot)).mean()
        
        return con_loss
    
    
    def forward(self, image, text, image_orig, text_orig, text_neg,
                clip_weight):
        image = self.preprocess(image)
        image_orig = self.preprocess(image_orig)
        rel = self.relative_clip_loss(image, text, image_orig, text_orig) 
        glob = self.global_contrastive_loss( image, text, text_neg)
        
        # print("rel", rel)
        # print("globa", glob)
        
        return clip_weight*rel + clip_weight*glob
        