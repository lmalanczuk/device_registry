# README

Your task is to implement the part of the application that helps track devices assigned to users within an organization.

For now, we have two ActiveRecord models: User and Device.
User can have many devices; the device should be active only for one assigned user.
There are 2 actions a User can take with the Device: assign the device to User or return the Device.

Here are the product requirements:
- User can assign the device only to themself. 
- User can't assign the device already assigned to another user.
- Only the user who assigned the device can return it. 
- If the user returned the device in the past, they can't ever re-assign the same device to themself.


TODO:
 - Clone this repo to your local machine - DON'T FORK IT.
 - Fix the config, so you can run the test suite properly.
 - Implement the code to make the tests pass for `AssignDeviceToUser` service.
 - Following the product requirements listed above, implement tests for returning the device and then implement the code to make them pass.
 - In case you are missing additional product requirements, use your best judgment. Have fun with it.
 - Refactor at will. Do you see something you don't like? Change it. It's your code. Remember to satisfy the outlined product requirements though.
 - Remember to document your progress using granular commits and meaningful commit messages.
 - Publish your code as a public repo using your Github account.
