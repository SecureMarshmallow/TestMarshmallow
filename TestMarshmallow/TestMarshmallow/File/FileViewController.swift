//
//  FileViewController.swift
//  TestMarshmallow
//
//  Created by 박준하 on 2023/05/10.
//

import UIKit

class FileViewController: UIViewController {
    
    override func viewDidLoad() {
          super.viewDidLoad()
          
          // 앱 내부 데이터 크기 출력
          if let appDataSize = getAppDataSize() {
              let formattedSize = ByteCountFormatter.string(fromByteCount: Int64(appDataSize), countStyle: .file)
              print("앱 내부 데이터 크기: \(formattedSize)")
          } else {
              print("앱 내부 데이터 크기를 가져올 수 없습니다.")
          }
          
          // 기기의 전체 디스크 용량 출력
          if let totalCapacity = deviceTotalCapacity() {
              let formattedSize = ByteCountFormatter.string(fromByteCount: Int64(totalCapacity), countStyle: .file)
              print("기기의 전체 디스크 용량: \(formattedSize)")
          } else {
              print("기기의 전체 디스크 용량을 가져올 수 없습니다.")
          }
          
          // 기기의 사용 가능한 디스크 용량 출력
          if let availableCapacity = deviceAvailableCapacity() {
              let formattedSize = ByteCountFormatter.string(fromByteCount: Int64(availableCapacity), countStyle: .file)
              print("기기의 사용 가능한 디스크 용량: \(formattedSize)")
          } else {
              print("기기의 사용 가능한 디스크 용량을 가져올 수 없습니다.")
          }
      }
      
      func getAppDataSize() -> UInt64? {
          // 앱 내부 데이터 크기를 반환합니다.
          let documentsDirectory = applicationDocumentsDirectory()
          return sizeOfDirectory(documentsDirectory)
      }
      
      func applicationDocumentsDirectory() -> URL {
          // 앱 내부의 데이터가 저장되는 경로를 반환합니다.
          let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
          let documentsDirectory = paths[0]
          return documentsDirectory
      }

      func sizeOfDirectory(_ directory: URL) -> UInt64? {
          // 지정된 경로의 폴더 크기
          do {
              let files = try FileManager.default.contentsOfDirectory(atPath: directory.path)
              var fileSize: UInt64 = 0
              for file in files {
                  let path = directory.appendingPathComponent(file)
                  let fileAttributes = try FileManager.default.attributesOfItem(atPath: path.path)
                  fileSize += fileAttributes[FileAttributeKey.size] as? UInt64 ?? 0
              }
              return fileSize
          } catch {
              return nil
          }
      }
      
      func deviceTotalCapacity() -> UInt64? {
          // 기기의 전체 디스크 용량
          if let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) {
              return attributes[.systemSize] as? UInt64
          }
          return nil
      }

      func deviceAvailableCapacity() -> UInt64? {
          // 기기의 사용 가능한 디스크 용량
          if let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) {
              return attributes[.systemFreeSize] as? UInt64
          }
          return nil
      }
  }
