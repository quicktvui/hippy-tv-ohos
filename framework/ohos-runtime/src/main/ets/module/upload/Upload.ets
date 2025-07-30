export interface Upload {
  id: number
  fileUrl: string
  fileMD5: string
  fileName: string
  fileType: string
  //
  fileLength?: number
  uploadLength?: number
  uploadPath?: string
}
