////
////  FileViewController.swift
////  TestMarshmallow
////
////  Created by 박준하 on 2023/05/10.
////
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

//import UIKit
//import SnapKit
//
//class FileViewController: UIViewController {
//
//    private let diskCapacityLabel = UITextView()
//    private let appDataSizeLabel = UITextView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .white
//
//        view.addSubview(diskCapacityLabel)
//        diskCapacityLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().offset(100)
//            make.width.equalToSuperview().offset(-40)
//            make.height.equalTo(60)
//        }
//
//        view.addSubview(appDataSizeLabel)
//        appDataSizeLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(diskCapacityLabel.snp.bottom).offset(20)
//            make.width.equalToSuperview().offset(-40)
//            make.bottom.equalToSuperview().offset(-100)
//        }
//
//        let diskCapacity = ByteCountFormatter.string(fromByteCount: deviceTotalCapacity(), countStyle: .file)
//        let availableCapacity = ByteCountFormatter.string(fromByteCount: deviceAvailableCapacity(), countStyle: .file)
//        diskCapacityLabel.text = "Total disk capacity: \(diskCapacity)\nAvailable capacity: \(availableCapacity)"
//
//        let appDataSize = ByteCountFormatter.string(fromByteCount: getAppDataSize(), countStyle: .file)
//        appDataSizeLabel.text = "App data size: \(appDataSize)"
//    }
//
//    private func deviceTotalCapacity() -> Int64 {
//        let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
//        let space = (systemAttributes?[.systemSize] as? NSNumber)?.int64Value
//        return space ?? 0
//    }
//
//    private func deviceAvailableCapacity() -> Int64 {
//        let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
//        let freeSpace = (systemAttributes?[.systemFreeSize] as? NSNumber)?.int64Value
//        return freeSpace ?? 0
//    }
//
//    private func getAppDataSize() -> Int64 {
//        let documentsDirectory = applicationDocumentsDirectory()
//        return sizeOfDirectory(documentsDirectory.path)
//    }
//
//    private func applicationDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentsDirectory = paths[0]
//        return documentsDirectory
//    }
//
//    private func sizeOfDirectory(_ path: String) -> Int64 {
//        var size: Int64 = 0
//        let fileManager = FileManager.default
//        guard let filesEnumerator = fileManager.enumerator(atPath: path) else { return 0 }
//        for file in filesEnumerator {
//            guard let filePath = filesEnumerator.fileAttributes?[.size] as? Int64 else { continue }
//            size += filePath
//        }
//        return size
//    }
//}
