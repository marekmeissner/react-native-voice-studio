#import "VoiceStudioView.h"

#import <React/RCTConversions.h>

#import <react/renderer/components/VoiceStudioViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/VoiceStudioViewSpec/Props.h>
#import <react/renderer/components/VoiceStudioViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"

using namespace facebook::react;

@implementation VoiceStudioView {
    UIView * _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<VoiceStudioViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const VoiceStudioViewProps>();
    _props = defaultProps;

    _view = [[UIView alloc] init];

    self.contentView = _view;
  }

  return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &oldViewProps = *std::static_pointer_cast<VoiceStudioViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<VoiceStudioViewProps const>(props);

    if (oldViewProps.color != newViewProps.color) {
        [_view setBackgroundColor: RCTUIColorFromSharedColor(newViewProps.color)];
    }

    [super updateProps:props oldProps:oldProps];
}

@end
