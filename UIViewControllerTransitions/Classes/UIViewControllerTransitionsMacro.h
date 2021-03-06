//
//  UIViewControllerTransitionsMacro.h
//  UIViewControllerTransitions
//
//  Created by Steve Kim on 5/12/16.
//  Modified by Steve Kim on 4/14/17.
//      - Renew design and add new feature interactive transition
//
//

#ifndef UIViewControllerTransitionsMacro_h
#define UIViewControllerTransitionsMacro_h

#define dispatch_after_sec(sec, completion) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(), completion)
#define CGRectMakeX(rect, x) CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height)
#define CGRectMakeXY(rect, x, y) CGRectMake(x, y, rect.size.width, rect.size.height)
#define CGRectMakeY(rect, y) CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height)
#define CGRectMakeW(rect, w) CGRectMake(rect.origin.x, rect.origin.y, w, rect.size.height)
#define CGRectMakeWH(rect, w, h) CGRectMake(rect.origin.x, rect.origin.y, w, h)
#define CGRectMakeH(rect, h) CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, h)

#endif /* UIViewControllerTransitionsMacro_h */
