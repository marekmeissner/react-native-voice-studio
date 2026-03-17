#import "VoiceStudioModule.h"

/**
 * When using Swift classes in ObjC implementation, the classes must be imported
 * from generated Objective-C Interface Header
 *
 * @see https://developer.apple.com/documentation/swift/importing-swift-into-objective-c#Import-Code-Within-an-App-Target
 */
#import "VoiceStudio-Swift.h"

/**
 * Import header file with codegenerated protocols based on the JS specification
 *
 * The name of the header matches the name provided in codegenConfig's `name` field in package.json
 */
#import "VoiceStudio.h"

// Each turbo module extends codegenerated spec class
@interface VoiceStudioModule () <VoiceStudioModuleDelegate>
@end

// Declare the ObjC implementation for that native module class
@implementation VoiceStudioModule {
  VoiceStudioModuleImpl *moduleImpl;
  RCTPromiseResolveBlock resolveBlock;
  RCTPromiseRejectBlock rejectBlock;
}

// Return the name of the module - it should match the name provided in JS specification
RCT_EXPORT_MODULE(VoiceStudio)

- (instancetype)init {
    self = [super init];
    if (self) {
        moduleImpl = [VoiceStudioModuleImpl new];
        moduleImpl.delegate = self;
    }
    return self;
}

// Declare if module should be initialized on the main queue
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

/**
 * If the module interacts with UIKit,
 * it can declare that its methods should be run on main queue
 */
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
    
// Implement RCTTurboModule protocol
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeVoiceStudioModuleSpecJSI>(params);
}

@end
