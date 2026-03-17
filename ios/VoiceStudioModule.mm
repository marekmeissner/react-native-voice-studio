#import "VoiceStudioModule.h"
#import "VoiceStudio-Swift.h"
#import "VoiceStudio.h"

@interface VoiceStudioModule () <VoiceStudioModuleDelegate>
@end

@implementation VoiceStudioModule {
  VoiceStudioModuleImpl *moduleImpl;
  RCTPromiseResolveBlock resolveBlock;
  RCTPromiseRejectBlock rejectBlock;
}

RCT_EXPORT_MODULE(VoiceStudio)

- (instancetype)init {
    self = [super init];
    if (self) {
        moduleImpl = [VoiceStudioModuleImpl new];
        moduleImpl.delegate = self;
    }
    return self;
}

+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

- (void)onSuccess
{
    if (resolveBlock != nil) {
        resolveBlock(@(YES));
    }
    resolveBlock = nil;
    rejectBlock = nil;
}

- (void)onError:(NSError *)error
{
    if (rejectBlock != nil) {
        rejectBlock([NSString stringWithFormat:@"%@", @(error.code)], error.localizedDescription, error);
    }
    resolveBlock = nil;
    rejectBlock = nil;
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(startRecording:(RCTPromiseResolveBlock)resolve
                      reject:(RCTPromiseRejectBlock)reject) {
    resolveBlock = resolve;
    rejectBlock = reject;
    [moduleImpl startRecordingSession];
}

RCT_EXPORT_METHOD(stopRecording) {
  [moduleImpl stopRecordingSession];
}
    
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeVoiceStudioModuleSpecJSI>(params);
}

@end
