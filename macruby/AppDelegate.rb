#
#  AppDelegate.rb
#  macruby
#
#  Created by Krzysztof Wicher on 11/01/2012.
#  Copyright 2012 MiK. All rights reserved.
#
framework 'AppKit'
framework 'Foundation'
require 'AnimationWindow'
class AppDelegate
    attr_accessor :window,:info
    attr_accessor :fromSeq, :toSeq
    attr_accessor :dirButton, :direction
    def applicationDidFinishLaunching(a_notification)
        @direction=:cs2nt
    end
    
    def flipToInfo(sender)
        flipp=AnimationWindow.alloc
        flipp.flip(@window,toBack:@info)
        
    end
    def flipToMain(sender)
        flipp=AnimationWindow.alloc
        flipp.flip(@info,toBack:@window)
        
    end
    
    def checkSeq(seqIn)
        return false if seqIn.length==0
        reg=(@direction==:cs2nt) ? /(^[ACGT][0123]+)/ : /(^[ACGT]+)/
        return seqIn.scan(reg).join.length==seqIn.length ? true : false
    end
    
    def say(sender)
        if(checkSeq(@fromSeq.string.upcase))
           @toSeq.string=(@direction==:cs2nt) ? cs2nt(@fromSeq.string.upcase) : nt2cs(@fromSeq.string.upcase)
        else
           puts "UPPS"
           al=NSAlert.alloc.init
            al.setMessageText("PROBLEM!!")
            al.setInformativeText("Check your input sequence")
           al.beginSheetModalForWindow(@window, modalDelegate:self, didEndSelector:nil, contextInfo:nil)
        end
    end
    
    def changeDir(sender)
        if @direction==:cs2nt 
            @direction=:nt2cs
            @dirButton.image=NSImage.alloc.initWithContentsOfFile(NSBundle.mainBundle.pathForResource("nt2cs", ofType:"png"))
        else
            @direction=:cs2nt
            @dirButton.image=NSImage.alloc.initWithContentsOfFile(NSBundle.mainBundle.pathForResource("cs2nt", ofType:"png"))
        end
    end
    
    def clearFrom(sender)
        fromSeq.string=""
    end
    def clearTo(sender)
        toSeq.string=""
    end
    def cs2nt(seq_in)
        dic={"0"=>{"A"=>"A","C"=>"C","G"=>"G","T"=>"T"},
            "1"=>{"A"=>"C","C"=>"A","G"=>"T","T"=>"G"},
            "2"=>{"A"=>"G","G"=>"A","T"=>"C","C"=>"T"},
            "3"=>{"A"=>"T","T"=>"A","G"=>"C","C"=>"G"}}
        
        seq_temp=seq_in[1..-1]
        f_base=seq_in[0]
        seq_out=f_base
        
        seq_temp.split(//).each do |ch|
            f_base=dic[ch][f_base]
            seq_out+=f_base
        end
        return seq_out
    end
    def nt2cs(seq_in)
        dic={"AA"=>"0", "CC"=>"0", "GG"=>"0", "TT"=>"0",
            "AC"=>"1", "CA"=>"1", "TG"=>"1", "GT"=>"1",
            "AG"=>"2", "GA"=>"2", "TC"=>"2", "CT"=>"2",
            "AT"=>"3", "TA"=>"3", "GC"=>"3", "CG"=>"3"}
        
        seq_temp=seq_in[1..-1]
        f_base=seq_in[0]
        seq_out=f_base
        
        seq_temp.split(//).each do |ch|
            seq_out+=dic[f_base+ch]
            f_base=ch
        end
        return seq_out
    end

end

