//
//  ViewController.swift
//  FilmListe
//
//  Created by Ruedi Heimlicher on 16.01.2024.
//

import Cocoa
import Foundation
import AVKit
import AVFoundation
import SwiftUI

let userDefaults = UserDefaults.standard

class rPlayerController: NSViewController 
{
    var player : AVPlayer!
    var playerLayer : CALayer!

    @IBOutlet weak var videoPlayer: AVPlayerView!

    override func viewDidLoad() 
   {
        super.viewDidLoad()

        guard let path = Bundle.main.path(forResource: "Background", ofType:"mp4") else 
      {
            debugPrint("Not found")
            return
        }
       playerLayer = AVPlayerLayer(player: player)
      
      let playerURL = AVPlayer(url: URL(fileURLWithPath: path))
      playerLayer.frame = self.view.bounds
      self.view.layer?.addSublayer(playerLayer)
        
      
      player.play()
    }
   
   @objc func setURL(filmURL:URL)
   {
      
      self.player = AVPlayer(url:filmURL)
      self.player.play()
      
   }
   required init?(coder  aDecoder : NSCoder) 
   {
      super.init(coder: aDecoder)
 //     self.player?.target = self
 //     self.Play?.action = #selector(ButtonUsed(_:))
    }
 
}// class rPlayerController



class rButtonZelle:NSTableCellView, NSMenuDelegate,NSTableViewDataSource,NSTabViewDelegate

{
   @IBOutlet weak var Play:NSButton?
   @IBOutlet weak var ImageButton:NSButton?
   
   var poptag:Int = 0
   var itemindex:Int = 0
   var tablezeile:Int = 0
   var tablekolonne:Int = 0
  
   
   @IBAction func buttonAction(_ sender: NSButton)
   {
      print("buttonAction tag: \(sender.tag)")
      let sup = self.superview?.superview as! NSTableView
      let zeile = sup.row(for: self)
      let kolonne = sup.column(for: self)
      let tabletag = sup.tag
      //itemindex = sender.indexOfSelectedItem
      print("popupAction tag: \(sender.tag)   ***    zeile: \(zeile) kolonne: \(kolonne)  tabletag: \(tabletag)")
      //print("sup: \(sup)")
      
      var notDic = [String:Int]()
      notDic["itemindex"] = itemindex
      notDic["zeile"] = zeile
      notDic["kolonne"] = kolonne
      notDic["tabletag"] = tabletag
      let nc = NotificationCenter.default
      nc.post(name:Notification.Name(rawValue:"tableplay"),
              object: nil,
              userInfo: notDic)

   }
   
   @IBAction func imageAction(_ sender: NSButton)
   {
      print("imageAction tag: \(sender.tag)")
      let sup = self.superview?.superview as! NSTableView
      let zeile = sup.row(for: self)
      let kolonne = sup.column(for: self)
      let tabletag = sup.tag
      
      print("imageAction tag: \(sender.tag)      zeile: \(zeile) kolonne: \(kolonne)  tabletag: \(tabletag)")
      //print("sup: \(sup)")
      
      var notDic = [String:Int]()
      notDic["itemindex"] = 0
      notDic["zeile"] = zeile
      notDic["kolonne"] = kolonne
      notDic["tabletag"] = tabletag
      let nc = NotificationCenter.default
      nc.post(name:Notification.Name(rawValue:"tableplay"),
              object: nil,
              userInfo: notDic)

   }

   @objc func ButtonUsed(_ sender: rButtonZelle) 
   {
       print("ButtonUsed \(sender.tag)")
   }
   
   required init?(coder  aDecoder : NSCoder) 
   {
      super.init(coder: aDecoder)
      //self.Play?.target = self
      //self.Play?.action = #selector(ButtonUsed(_:))
    }
   override init(frame: CGRect) 
   {
         super.init(frame: frame)
        // initialize what is needed
     }
  
}


class rViewController: NSViewController ,NSTableViewDelegate,NSTableViewDataSource,NSWindowDelegate
{

   var pfad = ""
   
    @IBOutlet weak var Quitknopf: NSButton!
    
   @IBOutlet weak var VolumeFeld: NSTextField!
   @IBOutlet weak var Filmordner: NSTextField!
   
   @IBOutlet weak var Filmtable: NSTableView!
    @IBOutlet weak var Kapitelpop: NSPopUpButton!
    
   @IBOutlet var playerView:AVPlayerView!
   
   var hintergrundfarbe = NSColor()
   var FilmArray = [[String:String]]()
   var fileURLArray = [URL]()
   
   var player : AVPlayer!
   
   var Playerfenster:rFilmController!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // https://developer.apple.com/forums/thread/654874      Filmtable.usesAutomaticRowHeights = true
      // Do any additional setup after loading the view.
      self.view.window?.acceptsMouseMovedEvents = true
      Filmtable.headerView?.frame = NSMakeRect(0, 0, (Filmtable.headerView?.frame.width)!, 32.00)
       Filmtable.headerView?.wantsLayer = true
      Filmtable.headerView?.layer?.backgroundColor = NSColor.red.cgColor
   
       Filmtable.cornerView?.wantsLayer = true
       Filmtable.cornerView?.layer?.backgroundColor = NSColor.red.cgColor
      //let view = view[0] as! NSView
      self.view.wantsLayer = true
      hintergrundfarbe  = NSColor.init(red: 8.0/255, 
                                       green: 111.0/255, 
                                       blue: 248.0/255, 
                                       alpha: 0.98)
      self.view.layer?.backgroundColor =  hintergrundfarbe.cgColor

      Playerfenster = rFilmController()
      NotificationCenter.default.addObserver(self, selector:#selector(PlayAktion(_:)),name:NSNotification.Name(rawValue: "tableplay"),object:nil)
       let fileManager = FileManager.default
       let volumeurl = userDefaults.object(forKey: "volumeurl") as?  String //"/Volumes/"
       self.pfad = "/Volumes"
       let HD = "TV_N"
       do
       {
           let items = try fileManager.contentsOfDirectory(atPath: pfad)
           
           for item in items
           {
               print("\t \(item)")
               
               if item == "TV_N"
               {/*
                   let path = "/Volumes/TV_N"
                   let s = try! String(contentsOfFile: path)
                   print(s)
*/
                   let inhalt = try fileManager.contentsOfDirectory(atPath:"/Volumes/TV_N")
               }
            
           }
           if let volumeurl = userDefaults.object(forKey: "volumeurl") as? URL {
               // let player = AVPlayer(url: defaultsUrl)
               let inhalt = try fileManager.contentsOfDirectory(at: volumeurl,includingPropertiesForKeys: nil)
               print("inhalt: \(inhalt)")
           }
           if volumeurl != nil
           {
               print("volumeurl \t \(volumeurl)")
               let inhalt = try fileManager.contentsOfDirectory(atPath:"/Volumes" )
               
               print("inhalt \t \t\(inhalt)")}
           
       }
       catch
       {
           print("failed to read directory")
                      
       }
       
       
       
       print("volumeurl: \(volumeurl)")
       
      Kapitelpop.removeAllItems()
       Playerfenster.showWindow(self)
   }
    
    override func viewDidAppear()
    {
        super.viewDidAppear()
        
        /*
        let volumenpfad = self.openDialog(pfad: "/Volumes/TV_N")
        print("viewDidAppear: \(viewDidAppear)")
        self.pfad = volumenpfad
        //readList()
         */
        self.openVolumeDialog(pfad: "/Volumers")
    }

   override var representedObject: Any? {
      didSet {
      // Update the view, if already loaded.
      }
   }
    
    @IBAction  func report_Quit(_ sender: NSButton)
    {
       print("quit")
        NSApp.terminate(self)
    }

    
   @objc func  PlayAktion(_ notification:Notification) 
   {
      let info = notification.userInfo
      let itemindex = info?["itemindex"] as! Int // 
      let zeile = info?["zeile"] as! Int 
      let kolonne = info?["kolonne"] as! Int 
      var tabletag = info?["tabletag"] as! Int 
      tabletag%=1000
      let playpfad = FilmArray[zeile]["pfad"]
      print("playpfad: \(playpfad)")
      /*
      guard let playURL = URL.init(string:playpfad!) else 
      {
         
         return  
         
      }
*/
      // https://stackoverflow.com/questions/65874089/open-a-short-video-using-quicktime-player
      let config = NSWorkspace.OpenConfiguration()
      config.activates = true
      let filmurl = fileURLArray[zeile]
      NSWorkspace.shared.open(
          [filmurl],
          withApplicationAt: URL(fileURLWithPath: "/System/Applications/QuickTime Player.app"),
          configuration: config
      )
      return
      
      
      var player = AVPlayer(url:fileURLArray[zeile])
      
      let videoURL = URL(string: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_5MB.mp4")
      //let player = AVPlayer(url: fileURLArray[zeile])
      
      //Filmfenster.setURL(filmURL: fileURLArray[zeile])
      
      //return
      let playerLayer:CALayer = AVPlayerLayer(player: player)
      
      playerLayer.frame = self.view.bounds
      self.view.layer?.addSublayer(playerLayer)
      player.volume = 0.8
      player.play()


         // https://stackoverflow.com/questions/53583672/how-to-play-a-video-in-a-macos-application-with-swift
      /*
      let player = AVPlayer(url:fileURLArray[zeile])
      
      //let videoURL = URL(string: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_5MB.mp4")
      //let player = AVPlayer(url: fileURLArray[zeile])
      let playerLayer = AVPlayerLayer(player: player)
      playerLayer.frame = self.view.bounds
      self.view.layer?.addSublayer(playerLayer)
      player.play()
*/
      
           
      
      
 //     playerView.player = player
//      
      var i=0
      print("\n* * * * PlayAktion itemindex:\t \(itemindex) zeile: \(zeile) kolonne: \(kolonne) tabletag: \(tabletag)")
      switch tabletag
      {
      case 1: // Kanal
         print("case 1") 
         i += 1
      default:
         i += 1
      }
   }
   @IBAction  func report_Open(_ sender: NSButton) // 
   {
      print("Pfad: *\(pfad)*")
      let openPanel = NSOpenPanel()
      openPanel.canChooseFiles = false
      openPanel.allowsMultipleSelection = false
      openPanel.canChooseDirectories = true
      openPanel.canCreateDirectories = false
       openPanel.canChooseFiles = false
       openPanel.showsHiddenFiles = false
       let volumeURL = URL.init(string: "/Volumes/TV_N")
       openPanel.directoryURL = volumeURL
      openPanel.title = "Select a folder"
      
      openPanel.beginSheetModal(for:self.view.window!) { (response) in
         if response.rawValue == NSApplication.ModalResponse.OK.rawValue 
         {
            let selectedPath = openPanel.url!.path
            // do whatever you what with the file path
            Swift.print("path: \(selectedPath)")
            self.pfad = selectedPath
            self.Filmordner.stringValue = selectedPath
         }
         openPanel.close()
          userDefaults.set(self.pfad, forKey: "volumeurl")
         self.readList()
      }
   }
    
    func openVolumeDialog(pfad: String)
    {
        let openPanel = NSOpenPanel()
        openPanel.prompt = "Select"
        openPanel.message = "Please select a folder"
        openPanel.allowedContentTypes = [.directory]
        openPanel.canChooseFiles = false
        openPanel.allowsOtherFileTypes = false
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        
        // Open the modal folder selection panel.
        let okButtonPressed = openPanel.runModal()
        
        if okButtonPressed == .OK {
            // If the user doesn't select anything, then the URL \"file:///\" is returned, which we ignore
            if let url = openPanel.urls.first,
               url.absoluteString != "file:///" {
                print("User selected folder: \\(url)")
                // Persist user selected folder for later launches
            } else {
                print("User did not select a folder")
            }
        } else {
            print("User cancelled folder selection panel")
        }
    }

    func openDialog(pfad: String)->String
    {
        print("Pfad: *\(pfad)*")
        var selectedPath:String = ""
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = false
        openPanel.showsHiddenFiles = false
        let volumeURL = URL.init(string: pfad)
        openPanel.directoryURL = volumeURL
        openPanel.title = "Select a folder"
        
        openPanel.beginSheetModal(for:self.view.window!)
        { (response) in
            if response.rawValue == NSApplication.ModalResponse.OK.rawValue
            {
                selectedPath = openPanel.url!.path
                // do whatever you what with the file path
                Swift.print("path: \(selectedPath)")
                self.pfad = selectedPath
                self.Filmordner.stringValue = selectedPath
            }
            openPanel.close()
            userDefaults.set(self.pfad, forKey: "volumeurl")
            
        }
        return selectedPath
    }
   
   func readList()
    {
        // von TV_Titel
        FilmArray.removeAll()
        
        //self.pfad = Filmordner.stringValue
        print("Pfad: \(pfad)")
        let fileManager = FileManager.default
        
        // https://www.hackingwithswift.com/example-code/system/how-to-read-the-contents-of-a-directory-using-filemanager
        do
        {
           //pfad = "/Volumes"
            let items = try fileManager.contentsOfDirectory(atPath: pfad)
            
            for item in items
            {
                print("\t \(item)")
            }
            
            for item in items
            {
                // 2020-05-30_13_45_ZDF_Inga-Lindstroem-Sommer-der-Erinnerung-00.03.11.879-01.30.41.619.mp4
                //print("Found \(item)")
                //print("item: \(item)")
                var titelarray =  item.components(separatedBy: " ")
                if titelarray.count == 1 // Ordner suchen
                {
                    let last = titelarray.last ?? "x"
                    print("ordner: \(last)")
                    Kapitelpop.addItem(withTitle: last)
                }

                let datum = titelarray[0]
                
                titelarray.removeFirst()
                var titelstring = titelarray.joined(separator: " ")
                 print("Datum: \(datum) titelstring: \(titelstring)")
                
                var titelpfad = pfad+"/"+item
                var titelurl = URL.init(string: titelpfad)
                //print ("titelpfad: \(titelpfad) url: \(titelurl)")
                
            } // for items
            
            
        }// do
        catch
        {
            print("failed to read directory")
            
            
        }
        
        let pfadurl = NSURL(fileURLWithPath: self.pfad)
        
        do {
           // let fileURLs = try FileManager.default.contentsOfDirectory(at: pfadurl as URL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]).filter(\.hasDirectoryPath)
            let fileURLs = try fileManager.contentsOfDirectory(at: pfadurl as URL, includingPropertiesForKeys: nil)
            print("fileURLs: \(fileURLs)")
              /*
             let player = AVPlayer(url:fileURLs[0])
             
             //let videoURL = URL(string: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_5MB.mp4")
             //let player = AVPlayer(url: fileURLArray[zeile])
             let playerLayer = AVPlayerLayer(player: player)
             playerLayer.frame = self.view.bounds
             self.view.layer?.addSublayer(playerLayer)
             player.play()
             */
            for filmzeile in fileURLs
            {
                fileURLArray.append(filmzeile)
                var filmzeilendic  = [String:String]()
                filmzeilendic["pfad"] = "neu"//filmzeile.path
                //filmzeilendic["viewed"] = "0"
                var zeilenarray =  filmzeile.path.components(separatedBy: "/")
                 let anz = zeilenarray.count
                
                
                let hiddenlist = ["Spotlight-V100",".DS_Store",".Trashes",".Spotlight-V100"]
                let last = zeilenarray.last ?? "x"
                if last.components(separatedBy: " ").count == 1 // Ordner suchen
                {
                    print("ordner: \(last)")
                    Kapitelpop.addItem(withTitle: last)
                }
                if hiddenlist.contains(last)
                {
                    continue
                }
                /*
                if zeilenarray.last?.prefix(1) == "."
                {
                    continue
                }*/
                
                
                let datumstring = zeilenarray.first
                let genrestring = zeilenarray[anz-2]
                let volumestring = zeilenarray[anz-3]
                let titelstring = zeilenarray.last
                filmzeilendic["titel"] = zeilenarray.last
                //print("filmzeile: \(filmzeile.path) volumestring: \(volumestring) genrestring: \(genrestring) titelstring: \(titelstring)")
                //print("filmzeilendic: \(filmzeilendic)")
                FilmArray.append(filmzeilendic)
                
            }// for urls
            //print("FilmArray: \(FilmArray)")
            Filmtable.reloadData()
            // process files
        } catch {
            print("Error while enumerating files \(pfadurl.path): \(error.localizedDescription)")
            
        }
        
    }// readList
   
 

}// ViewController

//MARK: dataTable
extension rViewController
{
   func numberOfRows(in tableView: NSTableView) -> Int 
   {
      
      return (FilmArray.count)
      
   }
   
   func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
      let zeile = FilmArray[row]
      //print("ident: \(tableColumn!.identifier.rawValue)")
      let ident = tableColumn!.identifier.rawValue
      if ident == "titel"
      {
         //print("Filmzeile: \(zeile)")
         let cell = tableView.makeView(withIdentifier: (tableColumn!.identifier), owner: self) as? NSTableCellView
         
         cell?.textField?.stringValue = (zeile[tableColumn!.identifier.rawValue]!)
         return cell
      }
      else if ident == "pfad"
      {
         let cell = tableView.makeView(withIdentifier: (tableColumn!.identifier), owner: self) as? NSTableCellView
         
         cell?.textField?.stringValue = (zeile[tableColumn!.identifier.rawValue]!)
         return cell

      }
      else if ident == "play"
      {
         //print("ident play")
         let cell = tableView.makeView(withIdentifier: (tableColumn!.identifier), owner: self) as? rButtonZelle
        // cell!.imageView?.image = NSImage(named:"play")
         return cell
      }
      else 
      {
         let cell = tableView.makeView(withIdentifier: (tableColumn!.identifier), owner: self) as? NSTableCellView
         return cell
         
      }
      
      
   }
}
