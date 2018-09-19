FROM nginx

RUN sed -i 'N; s/root   \/usr\/share\/nginx\/html;\n        index  index.html index.htm;/root   \/usr\/share\/nginx\/html;\n    add_before_body \/.theme\/header.html;\n    add_after_body \/.theme\/footer.html;\n    autoindex_exact_size off;\n        autoindex on;\n      auth_basic "Restricted";\n      auth_basic_user_file \/etc\/nginx\/.htpasswd;/' /etc/nginx/conf.d/default.conf
