// CKStub.m - neutralize CloudKit container init so resigned builds
// (enterprise certs without icloud entitlements) don't trap at launch.
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

__attribute__((constructor))
static void ckstub_init(void) {
    @autoreleasepool {
        Class ck = objc_getClass("CKContainer");
        if (!ck) return;

        // +defaultContainer -> nil
        Method m1 = class_getClassMethod(ck, @selector(defaultContainer));
        if (m1) {
            method_setImplementation(m1, imp_implementationWithBlock(^id(id self) {
                return nil;
            }));
        }

        // +containerWithIdentifier: -> nil
        SEL s2 = @selector(containerWithIdentifier:);
        Method m2 = class_getClassMethod(ck, s2);
        if (m2) {
            method_setImplementation(m2, imp_implementationWithBlock(^id(id self, id ident) {
                return nil;
            }));
        }

        // +currentUserRecordID -> error
        SEL s3 = @selector(currentUserRecordID);
        Method m3 = class_getClassMethod(ck, s3);
        if (m3) {
            method_setImplementation(m3, imp_implementationWithBlock(^id(id self) {
                return nil;
            }));
        }
    }
}
