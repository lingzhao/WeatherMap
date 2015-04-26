//
//  CardView.swift
//  WeatherAroundUs
//
//  Created by Kedan Li on 15/4/4.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

import UIKit
import Spring

class CardView: DesignableView, ImageCacheDelegate, InternetConnectionDelegate{

    var icon: UIImageView!
    var temperature: UILabel!
    var city: UILabel!
    var smallImage: UIImageView!
    var weatherDescription: UILabel!
    var parentViewController: ViewController!
    
    var iconBack: DesignableView!
    var temperatureBack: DesignableView!
    var cityBack: DesignableView!
    var weatherDescriptionBack: DesignableView!
    var smallImageBack: DesignableView!

    var iconBackCenter: CGPoint!
    var temperatureBackCenter: CGPoint!
    var cityBackCenter: CGPoint!
    var weatherDescriptionBackCenter: CGPoint!
    
    var smallImageEntered = false
    
    var hide = false
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let sideWidth:CGFloat = 6

    // get small city image from google
    func gotImageUrls(btUrl: String, imageURL: String, cityID: String) {
        var cache = ImageCache()
        cache.delegate = self
        cache.getSmallImageFromCache(btUrl, cityID: cityID)
    }
    
    func setup(){
        
        hide = false
        
        iconBack = DesignableView(frame: CGRectMake(sideWidth, sideWidth, self.frame.height * 0.75 - sideWidth * 2, self.frame.height * 0.75 - sideWidth * 2))
        self.addSubview(iconBack)
        addShadow(iconBack)
        addVisualEffectView(iconBack)
        icon = UIImageView(frame: CGRectMake(3, 3, iconBack.frame.width - 6, iconBack.frame.height - 6))
        iconBack.addSubview(icon)
        iconBackCenter = iconBack.center
        
        temperatureBack = DesignableView(frame: CGRectMake(sideWidth * 2 + iconBack.frame.width, iconBack.frame.width - self.frame.height * 0.2 + sideWidth, self.frame.height * 0.6, self.frame.height * 0.2))
        self.addSubview(temperatureBack)
        addShadow(temperatureBack)
        addVisualEffectView(temperatureBack)
        temperature = UILabel(frame: CGRectMake(3, 5, temperatureBack.frame.width - 6, temperatureBack.frame.height - 6))
        temperature.font = UIFont(name: "AvenirNext-Regular", size: 25)
        temperature.adjustsFontSizeToFitWidth = true
        temperature.textAlignment = NSTextAlignment.Center
        temperature.textColor = UIColor.darkGrayColor()
        temperatureBack.addSubview(temperature)
        temperatureBackCenter = temperatureBack.center

        cityBack = DesignableView(frame: CGRectMake(sideWidth, iconBack.frame.height + sideWidth * 2, iconBack.frame.width * 1.8, self.frame.height - iconBack.frame.height - 3 * sideWidth))
        self.addSubview(cityBack)
        addShadow(cityBack)
        addVisualEffectView(cityBack)
        city = UILabel(frame: CGRectMake(3, 3, cityBack.frame.width - 6, cityBack.frame.height - 6))
        city.font = UIFont(name: "AvenirNext-Medium", size: 22)
        city.textAlignment = NSTextAlignment.Center
        city.textColor = UIColor.darkGrayColor()
        cityBack.addSubview(city)
        cityBackCenter = cityBack.center
        
        weatherDescriptionBack = DesignableView(frame: CGRectMake(sideWidth * 2 + cityBack.frame.width, cityBack.frame.origin.y, self.frame.width - sideWidth * 3 - cityBack.frame.width, cityBack.frame.height))
        self.addSubview(weatherDescriptionBack)
        addShadow(weatherDescriptionBack)
        addVisualEffectView(weatherDescriptionBack)
        
        weatherDescription = UILabel(frame: CGRectMake(3, 3, weatherDescriptionBack.frame.width - 6, weatherDescriptionBack.frame.height - 6))
        weatherDescription.font = UIFont(name: "AvenirNext-Regular", size: 18)
        weatherDescription.textColor = UIColor.darkGrayColor()
        weatherDescription.textAlignment = NSTextAlignment.Center
        weatherDescriptionBack.addSubview(weatherDescription)
        weatherDescriptionBackCenter = weatherDescriptionBack.center
        
        smallImageBack = DesignableView(frame: CGRectMake(sideWidth + temperatureBack.frame.origin.x + temperatureBack.frame.width, temperatureBack.frame.origin.y, self.frame.width - sideWidth * 2 - temperatureBack.frame.origin.x - temperatureBack.frame.width, temperatureBack.frame.height))
        self.addSubview(smallImageBack)
        addShadow(smallImageBack)
        addVisualEffectView(smallImageBack)
        smallImage = UIImageView(frame: CGRectMake(3, 3, smallImageBack.frame.width - 6, smallImageBack.frame.height - 6))
        smallImage.alpha = 0.6
        smallImageBack.addSubview(smallImage)
        // move the image away at the beginning
        smallImageBack.center = CGPointMake(smallImageBack.center.x + temperatureBack.frame.width * 1.5, smallImageBack.center.y)

        hideSelf()
    }
 
    func displayCity(cityID: String){
            parentViewController.returnCurrentPositionButton.animation = "fadeOut"
            parentViewController.returnCurrentPositionButton.animate()
        
        if hide {
            hide = false
            self.userInteractionEnabled = true
            let info: AnyObject? = WeatherInfo.citiesAroundDict[cityID]
            self.icon.image = UIImage(named: (((WeatherInfo.citiesAroundDict[cityID] as! [String : AnyObject])["weather"] as! [AnyObject])[0] as! [String : AnyObject])["icon"] as! String)!
            
            var temp = ((info as! [String: AnyObject])["main"] as! [String: AnyObject])["temp"] as! Double
            temp = temp - 273
            let tempF = temp * 9 / 5 + 32
            self.temperature.text = "\(Int(temp))°C / \(Int(tempF))°F"
            self.city.text = (info as! [String: AnyObject])["name"] as? String

            self.weatherDescription.text = (((info as! [String: AnyObject])["weather"] as! [AnyObject])[0] as! [String: AnyObject])["main"]?.capitalizedString
            
            weatherDescriptionBack.center = weatherDescriptionBackCenter
            weatherDescriptionBack.animation = "slideLeft"
            weatherDescriptionBack.animate()
            cityBack.center = cityBackCenter
            cityBack.animation = "slideUp"
            cityBack.animate()
            iconBack.center = iconBackCenter
            iconBack.animation = "slideRight"
            iconBack.animate()
            temperatureBack.center = temperatureBackCenter
            temperatureBack.animation = "slideLeft"
            temperatureBack.animate()
            
        }else{
        
            iconBack.animation = "swing"
            iconBack.animate()
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.icon.alpha = 0
                self.temperature.alpha = 0
                self.city.alpha = 0
                self.weatherDescription.alpha = 0
                }) { (done) -> Void in
                    
                    let info: AnyObject? = WeatherInfo.citiesAroundDict[cityID]
                    self.icon.image = UIImage(named: (((WeatherInfo.citiesAroundDict[cityID] as! [String : AnyObject])["weather"] as! [AnyObject])[0] as! [String : AnyObject])["icon"] as! String)!
                    
                    var temp = ((info as! [String: AnyObject])["main"] as! [String: AnyObject])["temp"] as! Double
                    temp = temp - 273
                    let tempF = temp * 9 / 5 + 32
                    self.temperature.text = "\(Int(temp))°C / \(Int(tempF))°F"
                    self.city.text = (info as! [String: AnyObject])["name"] as? String
                    self.weatherDescription.text = ((((info as! [String: AnyObject])["weather"] as! [AnyObject])[0] as! [String: AnyObject])["main"])?.capitalizedString
                    
                    UIView.animateWithDuration(0.4, animations: { () -> Void in
                        self.icon.alpha = 1
                        self.temperature.alpha = 1
                        self.city.alpha = 1
                        self.weatherDescription.alpha = 1
                        }) { (done) -> Void in
                    }
            }
        }
    }
    
    func gotSmallImageFromCache(image: UIImage, cityID: String){
        
        if !hide{
            if !smallImageEntered{
                //not on screen yet
                smallImageEntered = true
                let theWidth = smallImageBack.frame.width
                let theHeight:CGFloat = image.size.height / image.size.width * theWidth
                smallImageBack.frame = CGRectMake(sideWidth + temperatureBack.frame.origin.x + temperatureBack.frame.width, weatherDescriptionBack.frame.origin.y - sideWidth - theHeight, theWidth, theHeight)
                (smallImageBack.subviews[0] as! UIView).frame = smallImageBack.bounds
                smallImageBack.animation = "slideLeft"
                smallImageBack.animate()
                smallImage.image = image
                smallImage.frame = CGRectMake(3, 3, smallImageBack.frame.width - 6, smallImageBack.frame.height - 6)
                
            }else{
                
                let theWidth = smallImageBack.frame.width
                let theHeight:CGFloat = image.size.height / image.size.width * theWidth
                let theFrame = CGRectMake(sideWidth + temperatureBack.frame.origin.x + temperatureBack.frame.width, weatherDescriptionBack.frame.origin.y - sideWidth - theHeight, theWidth, theHeight)
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.smallImageBack.frame = theFrame
                    (self.smallImageBack.subviews[0] as! UIView).frame = self.smallImageBack.bounds
                    self.smallImage.frame = CGRectMake(3, 3, self.smallImageBack.frame.width - 6, self.smallImageBack.frame.height - 6)
                })
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.smallImage.alpha = 0.3
                    }) { (finish) -> Void in
                        self.smallImage.image = image
                        UIView.animateWithDuration(0.25, animations: { () -> Void in
                            self.smallImage.alpha = 0.6
                        })
                }
            }
        }
    }
    
    func addVisualEffectView(view: UIView){
        var effectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        effectView.frame = view.bounds
        view.addSubview(effectView)
    }
    
    func addShadow(view: UIView){
        view.layer.shadowOffset = CGSizeMake(0, 1);
        view.layer.shadowRadius = 0.5;
        view.layer.shadowOpacity = 0.3;
    }

    
    func hideSelf(){

        if !hide {
            parentViewController.returnCurrentPositionButton.animation = "fadeIn"
            parentViewController.returnCurrentPositionButton.animate()
            
            hide = true
            self.userInteractionEnabled = false
            
            weatherDescriptionBack.center = CGPointMake(weatherDescriptionBack.center.x + weatherDescriptionBack.frame.width * 1.5, weatherDescriptionBack.center.y)
            weatherDescriptionBack.animation = "slideLeft"
            weatherDescriptionBack.animate()
            
            cityBack.center = CGPointMake(cityBack.center.x, cityBack.center.y + cityBack.frame.height * 1.5)
            cityBack.animation = "slideUp"
            cityBack.animate()
            
            iconBack.center = CGPointMake(iconBack.center.x - iconBack.frame.width * 1.5 , iconBack.center.y)
            iconBack.animation = "slideRight"
            iconBack.animate()
            
            temperatureBack.center = CGPointMake(temperatureBack.center.x, temperatureBack.center.y + temperatureBack.frame.height * 3.5)
            temperatureBack.animation = "slideUp"
            temperatureBack.animate()
    
            smallImageBack.center = CGPointMake(smallImageBack.center.x + temperatureBack.frame.width * 1.5, smallImageBack.center.y)
            smallImageBack.animation = "slideLeft"
            smallImageBack.animate()
            smallImageEntered = false
        }
    }
    
    func removeAllViews(){
        iconBack.removeFromSuperview()
        temperatureBack.removeFromSuperview()
        cityBack.removeFromSuperview()
        weatherDescriptionBack.removeFromSuperview()
        smallImageBack.removeFromSuperview()
    }

}
