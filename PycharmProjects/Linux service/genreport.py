$9����~Uy]�\�� (zM��ޢ i�̘Ri��|ͭߤ�R4�[�Y�����2ľ���E�p�e��{3����sK�ഢ%m�SC��c`{L9Ra4�������jV�Y��N�Nq&��t[탱��m��0K�\�iM�2�o��n_�*p^�&-��H���d�"z%;b>�v4�f8�z5Sx�-d0��Qa�łf�
�Ȃ�����H�fVn�
׬�Q�F�R~i�7�4���GVi�g^>4�*M'����>���@y`�k���G�l[|_�e���	�������QY���Z-��c�*��?w���ir_�@��l^p �'�i��{Wњ>]\c)}��s��j�ym�
z���;�PP0�o?����j���aI��(��Asyƒ)~�����aqz+2MZF�=����ZjQo��r�E%���*tT�@ü��󑥽:��؟��&rj��j�[cl&[� ����`E�ĨAP��m}��.�����8�}��|���ʽN��2�94 �U��7d��ߗ���D��iQ�;�?���X�2Q��u�|/�I�G|gKP�ڹ��BmG�p���������p���1��h��N�{�p����Z�7�>Ywϙ�E�b^��O^ȝ���.�Oj��8��]ef�ݟ��CK��?�쪾'���h�R��?u�k(�v�b��a6u&.�=׀�8��-6�~V�^��jv>��N�{��eq��q735CNm[(�`I�Yf���_�A#�&�,�s����},��oj#B�V���f�?[�%�1�r��	?�'������Qr3��#sp>h�38��zG� ;�o�|����ɧ��I
W�)f�S���XCg�p0�
�c���5a�J<�aK��0'�a96T?��P���=��e|s�nw�?m�\C�ӯ�.L Lm�l��^S��H�]�����?��ƃdY-S�+��eW���h�κ�SwT��<�1�I���-�%ǰoy+D��8>��u��W������`��0�_�0���"�\�LI���4,�3�\C����I�v���ss}:���u�"�y^��b�n2u�Y��P;w����HJ�4wR���ue�|�Z�����
�j���:'��G�V�^��.J���޽X����ǁ�r}������'�-`�y���~��-&(e�7V�C_�S��Ж��lu}E��MB���0Ql
e�$�� ��~���9V�F�z�g�7jnA?A�/m
��e�{�}�C��{�$�V(x-�Ha��H��sS�QH4G�Z����j����v(Gƽ��A*�(Z
M[�Z����.� ^n����5[h-Cw��*3�!�5�y�B�l�E䯧C:K�=U�z����KTQ�T/G��տ���d4����b;,��vx�t��Nc	�D{H��aw�v5:Z�A���zԠ���t��WH~k��c�0n�n�u�k݋|+������%�4�M��P$v�8��ҀF���m����|�o>dt��J�_U�i��H;%�u�	�!כ�������O{�BTǟܢ�*��~҄cn�W�^4T4�d%_��c�$y��{�rj�*�q�����F�@�-i�,�����6��{�eUnU�}�KB?u}3�Dz�M���4 DX�v�7�0�BAc����^L�-7�tL)8��ߌ: �;��^�p�.zgyg�J3�2�Km/7@᥍��0Ds���YL�,��������x{�A�W4^ҹO?���EoS�Ep��SO����u�ۚ�y+���0u�3"��b�D�49k��mܞ�Nذ�š�6mT��W<n4��?����h��f&s]�>VR��)���r b1�o��a���C��v�A�7�ێ�S~��䈪��}����i/�:G!���`%g�P�+��-�\��������⁠N4�}��r��3�A�S;:^ �Γ4Z������Zp�ظ�+�pK����ư<Go�llJ?y���A�y�:vkvz۔����������m-훈�g>كǁo� �].!!�^�;�v���o_���<A�$��Ss��ⵎ�^T&ꏜ�`�Tpj�7 o��sNJ��A����������s'���j���V��y�{�ݡ�8�����+V=L6u����d��?]���C�rq����؟�6�`U|&������jD�J4Im҉V�B��J����9�����g�`��O��U�N�<���i6��?�)c����M��G17F���鳣k�b�/:��5w��;�r�]��(��*�>����Pv2 <Ag��瑍�\� �M�c�����͆z�MAS�HZLHB�c|�;� �'����}���E�{�J�����löl�V2<����hI��\����U��Y�W���>�}�/�r�%ނV2h��۠�%�q�n��AP�.�^�����[h{�0�|�<H��Wf�g�:C!L��d �Nƫ���S����^�\�#���T(���J�rG�\���U�v�I0B���q�B�fH��
>t���.w(,�e��n���=��~�WTIME():
    from datetime import date
    import time
    now = date.today()
#    return now.strftime("%Y%b%d")+"_"+time.strftime('%H%M%S')
    return now.strftime("%Y%b%d")

#Return filename of Check Resule
def FILE():
    import os
    if os.path.exists('/tmp/OS_CHECK'):
        FN = '/tmp/OS_CHECK/OS_CHECK-'+NOWTIME()
        return FN
    else:
        os.system('mkdir -p /tmp/OS_CHECK')
        FN = '/tmp/OS_CHECK/OS_CHECK-'+NOWTIME()
        return FN



MAIN()