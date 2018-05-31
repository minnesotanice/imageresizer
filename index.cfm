<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Image Resizer</title>
	<link type="text/css" rel="stylesheet" href="style.css?v=6">
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script type="text/javascript" src="imageresizer.js"></script>
</head>

<body>

	<!--- 
	TO DO
	+ If form is submitted, run a JavaScript function hides the form and shows a 'clear' button
	+ add feature to select file type output (radio buttons)

	DONE
	+ get rid of error
	+ show .error text when any of the fields are not filled out
	+ add feature to reset the page (clear button)
	--->

	<h1>Image Resizer</h1>

	<!--- Pass in values for source image, final width, final height, canvas color --->
	<cfform name="resizerForm" id="jsForm" class="formClass" method="post">
		<div class="imageRequirements">
			<cfinput type="text" name="myImage" placeholder="Enter file path of image to edit. Acceptable file extentions include: .gif  .png  .jpg  .tif">
		</div>
		<div class="imageRequirements">
			<cfinput type="text" name="finalWidth" placeholder="Enter width in pixels">
		</div>
		<div class="imageRequirements">
			<cfinput type="text" name="finalHeight" placeholder="Enter height in pixels">
		</div>
		<div class="imageRequirements">
			<cfinput type="text" name="canvasColor" placeholder="Enter background color">
		</div>
		<div class="imageRequirements">
			<cfinput type="submit" name="" value="Edit this image">
		</div>
	</cfform>



	<!--- THE FORM WAS NOT FILLED OUT --->
 	<cfif isDefined( "FORM") and structKeyExists(FORM, "myImage")  and structKeyExists(FORM, "finalWidth")  and structKeyExists(FORM, "finalHeight")  and structKeyExists(FORM, "canvasColor") and (myImage eq "" || finalWidth eq "" || finalHeight eq "" || canvasColor eq "")>

		<div class="imageRequirements error">You must fill in all fields before submitting this form.</div>

	<!--- THE FORM WAS FILLED OUT! --->
	<!--- 	
	<cfelseif isDefined( "FORM") and structKeyExists(FORM, "myImage") and myImage neq "" and structKeyExists(FORM, "finalWidth") and finalWidth neq "" and structKeyExists(FORM, "finalHeight") and finalHeight neq "" and structKeyExists(FORM, "canvasColor") and canvasColor neq "">
	 --->	
	<cfelseif isDefined( "FORM") and structKeyExists(FORM, "myImage") and structKeyExists(FORM, "finalWidth") and structKeyExists(FORM, "finalHeight") and structKeyExists(FORM, "canvasColor") and (myImage neq "" and finalWidth neq "" and finalHeight neq "" and canvasColor neq "")>

		<!--- Run a JavaScript function hides the form and shows a 'clear' button --->
		<script type="text/javascript">
			showClear();
			hideForm();
		</script>

		<!--- Create variable for URL that was entered in the form --->
		<cfset originalURL = myImage>

		<!--- Create image resource from original image link entered in form --->
		<cfset myImage = ImageRead(myImage)>
		
		<!--- Turn on antialiasing --->
		<cfset ImageSetAntialiasing(myImage, "off")>

		<!--- Scale to fit width and height entered in form --->
		<cfset ImageScaleToFit(myImage,finalWidth,finalHeight)>


		<!--- CALCULATIONS --->

		<!--- Measure myImage --->
		<cfset myImageWidth=ImageGetWidth(myImage)>
		<cfset myImageHeight=ImageGetHeight(myImage)>

		<!--- Figure out positioning on canvas --->
		<!--- difference in width --->
		<cfset widthDifference = finalWidth - myImageWidth>

		<!--- difference in height --->
		<cfset heightDifference = finalHeight - myImageHeight>

		<!--- offset x position on canvas --->
		<cfset widthOffset = widthDifference/2>

		<!--- offset y on canvas --->
		<cfset heightOffset = heightDifference/2>


		<!--- EDITED IMAGE --->
		<!--- Create canvas --->
		<cfset myCanvas = ImageNew( "",finalWidth,finalHeight, "rgb",canvasColor)>
		<cfset ImageSetAntialiasing(myCanvas, "off")>

		<!--- Paste and center image on canvas --->
		<cfset imagePaste(myCanvas, myImage, widthOffset, heightOffset)>


		<!--- CLEAR RESULTS LINK --->
		<div class="divButtonDisplay">
			<a href="" class="divButton">Clear Results</a>
		</div>

		<!--- DISPLAY DATA ENTERED INTO FORM --->
		<cfoutput>
			<div class="imageRequirements">
				Original image: 
				<a href="#originalURL#" target="_blank">
					#originalURL#
				</a>
			</div>
			<div class="imageRequirements">
				New width: #finalWidth#
			</div>
			<div class="imageRequirements">
				New height: #finalHeight#
			</div>
			<div class="imageRequirements">
				Background color: #canvasColor#
			</div>
		</cfoutput>

		<!--- SHOW EDITED IMAGE --->
		<div class="finalImageDisplay">
			<!--- Write image to browser in gif format --->
			<cfimage source="#myCanvas#" action="writeToBrowser" format="gif">
		</div>

	<cfelse>
		<!--- DO NOTHING --->
	</cfif>
	
	
	<!--- INTERESTING NOTES --->
	<!--- https://helpx.adobe.com/coldfusion/developing-applications/working-with-documents-charts-and-reports/creating-and-manipulating-coldfusion-images/manipulating-coldfusion-images.html --->
	<!--- https://www.raymondcamden.com/2009/09/04/Increasing-the-canvas-size-of-an-image/ --->

</body>

</html>
