

import SwiftUI

let fileManager = FileManager.default
let documentFolder = fileManager.urls(for : .documentDirectory , in : .userDomainMask)[0]



func FindFile (_ filename : String) -> URL? {
    
    let fileUrl = documentFolder.appendingPathComponent(filename)
    
    guard fileManager.fileExists(atPath: fileUrl.path) else { return nil }
    return fileUrl
}



func WriteFile (to filename : String , content : String){
    let fileUrl = documentFolder.appendingPathComponent(filename)
    
    do {
        try content.write(to : fileUrl , atomically: true , encoding: .utf8)
        print("file wrote successfully at \(fileUrl.path)")
    }
    catch {
        print("file writing failed , error : \(error.localizedDescription)")
    }
}



func ReadFile(from filename : String) -> String? {
    let fileUrl = FindFile(filename)
    if let url = fileUrl{
        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            return content
        }
        catch {
            print("error reading file \(error.localizedDescription)")
        }
        
    }else{
        print("\(filename) does not exist")
    }
    return nil
}



func AppendFile (named filename : String , content : String) {
    let fileUrl = documentFolder.appendingPathComponent(filename)
    let str = (ReadFile(from : filename) ?? "") + content
    
    do {
        try str.write(to : fileUrl , atomically: true , encoding: .utf8)
    } catch {
        print("error occured \(error.localizedDescription)")
    }
}


func DeleteFile (named filename : String){
    let fileUrl = FindFile(filename)
    
    if let url = fileUrl{
        do {
            try fileManager.removeItem(at: url)
            print("file deleted")
        }
        catch {
            print("file deletion failed, error : \(error.localizedDescription)")
        }
    }
}

func OpenFolder(open filename : String){
    if let fileurl = FindFile(filename) {
        NSWorkspace.shared.open(fileurl)
    } else {
        print("folder path does not exist.")
    }
}

func PromptFolder(title : String , prompt : String) -> URL? {
    let panel = NSOpenPanel()
    panel.title = title
    panel.prompt = prompt
    panel.allowsMultipleSelection = false
    panel.canChooseDirectories = true
    panel.canChooseFiles = false
    
    if panel.runModal() == .OK {
        return panel.urls.first
    }
    return nil
}

func PromptFile(title : String , prompt : String) -> URL? {
    let panel = NSOpenPanel()
    panel.title = title
    panel.prompt = prompt
    panel.allowsMultipleSelection = false
    panel.canChooseDirectories = false
    panel.canChooseFiles = true
    
    if panel.runModal() == .OK {
        return panel.urls.first
    }
    return nil
}

func Prompt(title : String , prompt : String , type : String ) -> URL?{
    let panel = NSOpenPanel()
    panel.title = title
    panel.prompt = prompt
    panel.allowsMultipleSelection = false
    switch type {
        case "folder":
            panel.canChooseDirectories = true
            panel.canChooseFiles = false
        case "file":
            panel.canChooseDirectories = false
            panel.canChooseFiles = true
        default:
            print("invalid type")
            return nil
    }
    if panel.runModal() == .OK {
        return panel.urls.first
    }
    return nil
    
}

func getExtension(file : URL) -> String{
    let extensionName = file.pathExtension.lowercased()
    
    switch extensionName {
    case "txt":
        return "text"
    case "png":
        return "image"
    case "jpg":
        return "image"
    case "jpeg":
        return "image"
    case "pdf":
        return "pdf"
    default:
        return "-"
    }
}

func copyNew(copy file : URL , at destination : String) {
    let destinationFolderURL = documentFolder.appendingPathComponent(destination)
    guard fileManager.fileExists(atPath: destinationFolderURL.path) else {return}
    
    
    let destinationURL = destinationFolderURL.appendingPathComponent(file.lastPathComponent)

    
    if !(fileManager.fileExists(atPath: destinationURL.path)){
        do {
            try fileManager.copyItem(at: file, to: destinationURL)
            print("successfully copied file to \(destinationURL.path)")
        } catch {
            print("failed to copy file to \(destinationURL.path)   [error : \(error.localizedDescription)]")
        }
    }else{
        print("file already exists in that path")
    }
}

func createDirectory(folderName name : String , at destination : String) {
    let atLocation = documentFolder.appendingPathComponent(destination)
    
    guard fileManager.fileExists(atPath: atLocation.path) else {return}
    let folderLocation = atLocation.appendingPathComponent(name)
    
    print(folderLocation.path)

    if !fileManager.fileExists(atPath: folderLocation.path){
        do {
            try fileManager.createDirectory(at : folderLocation, withIntermediateDirectories : true)
        } catch {
            print("could not create folder \(error.localizedDescription)")
        }
    }else {print("folder with the name \(name) already exists")}
}
