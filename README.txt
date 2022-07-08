# psg/README.txt 

git is now primarly storage for pocket sysadmin survival guide
- github
- gitlab


skinforum.org vm in arv
psg.ask-margo.com is hosted in aws as s3.  sometime ago may have synced using api cli, but 2022.07.06 just used web to upload the files, not .git db, which aren't really needed as never run git pull on the s3 bucket anyway.
	consider running cronjob on some host with s3 api that pull and upload.  
	bofh has the aws cli toolkit installed.  or run these commands manually:

	cd ~/PSG
	aws s3 sync . s3://psg.ask-margo.com --acl public-read --exclude ".git/*" # serves http://psg.ask-margo.com
	aws s3 sync . s3://tin6150           --acl public-read --exclude ".git/*" # serves http://tin6150.s3-website-us-west-1.amazonaws.com/ # can drop
                                                                            # exclude .git DB files
  aws s3 cp   fig s3://tin6150/    --acl public-read  --recursive         # cp -R  fig folder copied and folder created in dest bucket

	these buckets not likely serving any web sites, just old sync tests:

	aws s3 ls sapsg/index.html		# 2020-10-28  NOT http://psg.ask-margo.com  , may not be useful
	ask-margo.com/index.html			# 2016
	ask-margo											# empty
	www.ask-margo.com/index.html  # 2016

AWS Route 53 sites:																		Value/Route traffic to:
http://tin6150.s3-website-us-west-1.amazonaws.com/	 	s3 bucket: tin6150/  		
w3.ask-margo.com																			CNAME to tin6150.s3-website-us-west-1.amazonaws.com

cache.ask-margo.com																		back to arvixe hosted

ask-margo.com																					s3-website-us-west-1.amazonaws.com  # s3 bucket: psg.ask-margo.com/
psg.ask-margo.com
www.ask-margo.com 

2022.07.07
