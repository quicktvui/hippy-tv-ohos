import { Download } from "./Download";
import {
  DownloadProgressListener,
  DownloadStatusListener
} from "./DownloadListener";
import request from '@ohos.request';
import QTAppManager from "../../quick/QTAppManager";
import { DownloadTask } from "./DownloadTask";
import { LogUtils } from 'hippy';
import { DownloadMessage } from "./DownloadMessage";
import { DownloadStatus } from "./DownloadStatus";
import { DownloadProgress } from "./DownloadProgress";
import { DownloadState } from "./DownloadState";

/**
 *
 */
export class DownloadManager {
  private readonly TAG = 'DownloadManager';
  //
  private readonly TASK_MAX: number = 10;
  //
  private static instance: DownloadManager;
  private waitList: Array<Download> = [];
  private backgroundTasks: Array<DownloadTask> = [];
  private statusListener: Set<DownloadStatusListener> = new Set();
  private progressListener: Set<DownloadProgressListener> = new Set();
  private context: Context | null = null;

  private constructor() {
  }

  static getInstance(): DownloadManager {
    if (!DownloadManager.instance) {
      DownloadManager.instance = new DownloadManager();
    }
    return DownloadManager.instance;
  }

  public init(context: Context) {
    this.context = context
  }

  private async flushBackgroundTask() {
    let runningTasks = await request.agent.search({
      state: request.agent.State.RUNNING
    });
    if (runningTasks.length < this.TASK_MAX && this.waitList.length > 0) {
      const allowed = this.TASK_MAX - runningTasks.length;
      const toDownload = this.waitList.splice(0, allowed);
      await this.createBackgroundTasks(toDownload);
    }
  }

  private async createBackgroundTasks(downloads: Download[]) {
    for (const download of downloads) {
      if (!this.backgroundTasks.find(t => t.getDownload()?.fileUrl === download.fileUrl)) {
        const path =
          QTAppManager.getInstance().getESAppFilePath(this.context!) + "/download/" +
          download.fileName
        download.downloadPath = path
        const downloadTask: DownloadTask = new DownloadTask(this.context!)
        downloadTask.download(download)
        downloadTask.setDownloadStatusListener((downloadStatus: DownloadStatus<DownloadMessage>) => {
          this.notifyDownloadStatusChanged(downloadStatus)
          //
          if (downloadStatus.state == DownloadState.DOWNLOAD_STATE_ERROR ||
            downloadStatus.state == DownloadState.DOWNLOAD_STATE_SUCCESS) {
            this.flushBackgroundTask()
          }
        })
        downloadTask.setDownloadProgressListener((downloadProgress: DownloadStatus<DownloadProgress>) => {
          this.notifyDownloadProgressChanged(downloadProgress)
        })
        this.backgroundTasks.push(downloadTask);
      } else {
        LogUtils.i(this.TAG, 'download already in task!' + JSON.stringify(download));
      }
    }
  }

  public async download(download: Download) {
    this.waitList.push(download)
    this.flushBackgroundTask()
  }

  public start(download: Download) {
    const downloadTask =
      this.backgroundTasks.find(t => t.getDownload()?.fileUrl === download.fileUrl)
    if (downloadTask) {
      downloadTask.start()
    }
  }

  public stop(download: Download) {
    const downloadTask =
      this.backgroundTasks.find(t => t.getDownload()?.fileUrl === download.fileUrl)
    if (downloadTask) {
      downloadTask.stop()
    }
  }

  public async pause(download: Download) {
    const downloadTask =
      this.backgroundTasks.find(t => t.getDownload()?.fileUrl === download.fileUrl)
    if (downloadTask) {
      downloadTask.pause()
    }
  }

  public async pauseAll() {
    for (const task of this.backgroundTasks) {
      try {
        await task.pause();
      } catch (err) {
        LogUtils.e(this.TAG, `Pause error: ${JSON.stringify(err)}`);
      }
    }
  }

  public async resume(download: Download) {
    const downloadTask =
      this.backgroundTasks.find(t => t.getDownload()?.fileUrl === download.fileUrl)
    if (downloadTask) {
      downloadTask.resume()
    }
  }

  public async resumeAll() {
    for (const task of this.backgroundTasks) {
      try {
        await task.resume();
      } catch (err) {
        LogUtils.e(this.TAG, `Resume error: ${JSON.stringify(err)}`);
      }
    }
  }

  public cancel(download: Download) {
    const downloadTask =
      this.backgroundTasks.find(t => t.getDownload()?.fileUrl === download.fileUrl)
    if (downloadTask) {
      downloadTask.cancel()
    }
  }

  public release() {
    for (const downloadTask of this.backgroundTasks) {
      downloadTask.stop()
      downloadTask.cancel()
      downloadTask.release()
    }
  }

  public registerDownloadStatusListener(listener: DownloadStatusListener) {
    this.statusListener.add(listener);
  }

  public unregisterDownloadStatusListener(listener: DownloadStatusListener) {
    this.statusListener.delete(listener);
  }

  public registerDownloadProgressListener(listener: DownloadProgressListener) {
    this.progressListener.add(listener);
  }

  public unregisterDownloadProgressListener(listener: DownloadProgressListener) {
    this.progressListener.delete(listener);
  }

  private notifyDownloadStatusChanged(downloadStatus: DownloadStatus<DownloadMessage>) {
    this.statusListener.forEach((listener) => {
      listener(downloadStatus)
    })
  }

  private notifyDownloadProgressChanged(downloadProgress: DownloadStatus<DownloadProgress>) {
    this.progressListener.forEach((listener) => {
      listener(downloadProgress)
    })
  };
}
